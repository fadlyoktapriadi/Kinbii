import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:kinbii/data/services/backup_service.dart';

class BackupController extends GetxController {
  final BackupService backupService;

  BackupController(this.backupService);

  var isProcessing = false.obs;
  var errorMessage = ''.obs;

  Future<String?> backupData() async {
    if (isProcessing.value) return null;
    isProcessing.value = true;
    errorMessage.value = '';

    try {
      final hasAccess = await _ensureFileAccessPermission();
      if (!hasAccess) {
        throw Exception('Storage permission is required');
      }

      final backupJson = await backupService.exportBackupAsJson();
      final bytes = Uint8List.fromList(utf8.encode(backupJson));
      final fileName = _createBackupFileName();

      final savedPath = await FilePicker.platform.saveFile(
        dialogTitle: 'Save Kinbii backup',
        fileName: fileName,
        type: FileType.custom,
        allowedExtensions: ['json'],
        bytes: bytes,
      );

      return savedPath;
    } catch (e) {
      errorMessage.value = e.toString();
      return null;
    } finally {
      isProcessing.value = false;
    }
  }

  Future<bool> importDataFromBackup() async {
    if (isProcessing.value) return false;
    isProcessing.value = true;
    errorMessage.value = '';

    try {
      final hasAccess = await _ensureFileAccessPermission();
      if (!hasAccess) {
        throw Exception('Storage permission is required');
      }

      final picked = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
        withData: true,
      );

      if (picked == null || picked.files.isEmpty) {
        return false;
      }

      final selected = picked.files.single;
      final bytes = await _resolveFileBytes(selected);
      await backupService.importBackupFromBytes(bytes);
      return true;
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    } finally {
      isProcessing.value = false;
    }
  }

  Future<Uint8List> _resolveFileBytes(PlatformFile file) async {
    if (file.bytes != null) {
      return file.bytes!;
    }
    if (file.path != null) {
      return File(file.path!).readAsBytes();
    }
    throw const FormatException('Selected file cannot be read');
  }

  Future<bool> _ensureFileAccessPermission() async {
    if (!Platform.isAndroid) {
      return true;
    }

    final androidInfo = await DeviceInfoPlugin().androidInfo;
    if (androidInfo.version.sdkInt >= 33) {
      return true;
    }

    final currentStatus = await Permission.storage.status;
    if (currentStatus.isGranted) {
      return true;
    }

    final requestedStatus = await Permission.storage.request();
    return requestedStatus.isGranted;
  }

  String _createBackupFileName() {
    final now = DateTime.now().toIso8601String();
    final compact = now.replaceAll(':', '-');
    return 'kinbii_backup_$compact.json';
  }
}
