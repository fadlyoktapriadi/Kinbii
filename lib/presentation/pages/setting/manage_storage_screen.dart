import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart';
import 'package:kinbii/theme/app_theme.dart';
import 'package:kinbii/di/injection.dart';
import 'package:kinbii/presentation/controllers/storage_controller.dart';
import 'package:kinbii/data/models/storage_model.dart';

class ManageStorageScreen extends StatefulWidget {
  const ManageStorageScreen({super.key});

  @override
  State<ManageStorageScreen> createState() => _ManageStorageScreenState();
}

class _ManageStorageScreenState extends State<ManageStorageScreen> {
  final _storageController = TextEditingController();
  final StorageController controller = Get.put(sl<StorageController>());

  void _addStorage() {
    if (_storageController.text.isNotEmpty) {
      controller.addStorage(_storageController.text);
      _storageController.clear();
    }
  }

  void _showAddStorageSheet() {
    _storageController.clear();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20.w,
            right: 20.w,
            top: 20.h,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Add Storage', style: AppTheme.appTextStyles.header2),
              SizedBox(height: 16.h),
              TextFormField(
                controller: _storageController,
                decoration: InputDecoration(
                  hintText: 'Storage Name',
                  hintStyle: AppTheme.appTextStyles.bodyMedium.copyWith(
                    color: AppTheme.appColors.grey,
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => context.pop(),
                    child: Text('Cancel', style: TextStyle(color: AppTheme.appColors.grey)),
                  ),
                  SizedBox(width: 12.w),
                  ElevatedButton(
                    onPressed: () {
                      if (_storageController.text.isNotEmpty) {
                        _addStorage();
                        context.pop();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.appColors.primary,
                    ),
                    child: Text('Add', style: TextStyle(color: AppTheme.appColors.white)),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showEditDeleteBottomSheet(BuildContext context, int index, StorageModel storage) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.edit, color: AppTheme.appColors.info),
                title: Text('Edit', style: AppTheme.appTextStyles.bodyLarge),
                onTap: () {
                  context.pop();
                  _showEditDialog(index, storage);
                },
              ),
              ListTile(
                leading: Icon(Icons.delete, color: AppTheme.appColors.danger),
                title: Text('Delete', style: AppTheme.appTextStyles.bodyLarge),
                onTap: () {
                  if (storage.id != null) {
                    controller.deleteStorage(storage.id!, index);
                  }
                  context.pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showEditDialog(int index, StorageModel storage) {
    final editController = TextEditingController(text: storage.name);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Storage', style: AppTheme.appTextStyles.header2),
          content: TextFormField(
            controller: editController,
            decoration: InputDecoration(
              hintText: 'Storage Name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => context.pop(),
              child: Text('Cancel', style: TextStyle(color: AppTheme.appColors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                if (editController.text.isNotEmpty) {
                  controller.updateStorage(
                    index,
                    storage.copyWith(name: editController.text),
                  );
                  context.pop();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.appColors.primary,
              ),
              child: Text('Save', style: TextStyle(color: AppTheme.appColors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _storageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Storage', style: AppTheme.appTextStyles.header2),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 20.w),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                }
                if (controller.storages.isEmpty) {
                  return Center(child: Text("No storages found", style: AppTheme.appTextStyles.bodyMedium));
                }
                return ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                  itemCount: controller.storages.length,
                  separatorBuilder: (context, index) => SizedBox(height: 12.h),
                  itemBuilder: (context, index) {
                    final storage = controller.storages[index];
                    return Container(
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
                      child: ListTile(
                        title: Text(
                          storage.name,
                          style: AppTheme.appTextStyles.header3,
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.more_vert, color: AppTheme.appColors.grey),
                          onPressed: () => _showEditDeleteBottomSheet(context, index, storage),
                        ),
                        onTap: () => _showEditDeleteBottomSheet(context, index, storage),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddStorageSheet,
        backgroundColor: AppTheme.appColors.primary,
        child: Icon(Icons.add, color: AppTheme.appColors.white),
      ),
    );
  }
}

