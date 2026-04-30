import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:kinbii/di/injection.dart';
import 'package:kinbii/presentation/controllers/backup_controller.dart';
import 'package:kinbii/presentation/controllers/category_controller.dart';
import 'package:kinbii/presentation/controllers/product_controller.dart';
import 'package:kinbii/presentation/controllers/report_controller.dart';
import 'package:kinbii/presentation/controllers/storage_controller.dart';
import 'package:kinbii/theme/app_theme.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  BackupController get backupController => Get.isRegistered<BackupController>()
      ? Get.find<BackupController>()
      : Get.put(sl<BackupController>());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Settings',
                style: AppTheme.appTextStyles.header2,
              ),
              SizedBox(height: 32.h),
              _buildSettingItem(
                context,
                icon: Icons.category_outlined,
                title: 'Manage Category',
                subtitle: 'Add, edit, or delete categories',
                onTap: () {
                  context.push('/manage-category');
                },
              ),
              SizedBox(height: 16.h),
              _buildSettingItem(
                context,
                icon: Icons.inventory_2_outlined,
                title: 'Manage Storage',
                subtitle: 'Manage storage locations',
                onTap: () {
                  context.push('/manage-storage');
                },
              ),
              SizedBox(height: 16.h),
              _buildSettingItem(
                context,
                icon: Icons.assessment_outlined,
                title: 'Report Product',
                subtitle: 'View product in/out reports',
                onTap: () {
                  context.push('/report-product');
                },
              ),
              SizedBox(height: 16.h),
              Obx(() {
                return _buildSettingItem(
                  context,
                  icon: Icons.backup_outlined,
                  title: 'Backup Data',
                  subtitle: backupController.isProcessing.value
                      ? 'Backing up...'
                      : 'Export all SQFlite data to JSON',
                  onTap: backupController.isProcessing.value
                      ? () {}
                      : () async {
                          final savedPath = await backupController.backupData();
                          if (!context.mounted) return;

                          if (savedPath == null) {
                            final err = backupController.errorMessage.value;
                            if (err.isNotEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Backup failed: $err')),
                              );
                            }
                            return;
                          }

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Backup file created: $savedPath'),
                            ),
                          );
                        },
                );
              }),
              SizedBox(height: 16.h),
              Obx(() {
                return _buildSettingItem(
                  context,
                  icon: Icons.file_upload_outlined,
                  title: 'Import Backup',
                  subtitle: backupController.isProcessing.value
                      ? 'Importing...'
                      : 'Replace all data with backup file',
                  onTap: backupController.isProcessing.value
                      ? () {}
                      : () async {
                          final allowImport = await _showImportConfirmDialog(context);
                          if (!allowImport || !context.mounted) return;

                          final success = await backupController.importDataFromBackup();
                          if (!context.mounted) return;

                          if (!success) {
                            final err = backupController.errorMessage.value;
                            if (err.isNotEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Import failed: $err')),
                              );
                            }
                            return;
                          }

                          await _refreshAllControllers();
                          if (!context.mounted) return;

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Import completed and data refreshed'),
                            ),
                          );
                        },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _showImportConfirmDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Import backup?'),
          content: const Text(
            'All current data will be deleted and replaced by backup data.',
          ),
          actions: [
            TextButton(
              onPressed: () => dialogContext.pop(false),
              child: Text(
                'Cancel',
                style: TextStyle(color: AppTheme.appColors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: () => dialogContext.pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.appColors.danger,
              ),
              child: Text(
                'Import',
                style: TextStyle(color: AppTheme.appColors.white),
              ),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }

  Future<void> _refreshAllControllers() async {
    final categoryController = Get.isRegistered<CategoryController>()
        ? Get.find<CategoryController>()
        : Get.put(sl<CategoryController>());
    final storageController = Get.isRegistered<StorageController>()
        ? Get.find<StorageController>()
        : Get.put(sl<StorageController>());
    final productController = Get.isRegistered<ProductController>()
        ? Get.find<ProductController>()
        : Get.put(sl<ProductController>());
    final reportController = Get.isRegistered<ReportController>()
        ? Get.find<ReportController>()
        : Get.put(sl<ReportController>());

    await Future.wait([
      categoryController.fetchCategories(),
      storageController.fetchStorages(),
      productController.fetchProducts(),
      reportController.fetchMovements(),
    ]);
  }

  Widget _buildSettingItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppTheme.appColors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: AppTheme.appColors.softGrey.withValues(alpha: 0.3),
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: AppTheme.appColors.softGrey.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: AppTheme.appColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: AppTheme.appColors.primary,
                size: 24.w,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.appTextStyles.header3,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: AppTheme.appTextStyles.bodyMedium.copyWith(
                      color: AppTheme.appColors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: AppTheme.appColors.grey,
              size: 20.w,
            ),
          ],
        ),
      ),
    );
  }
}
