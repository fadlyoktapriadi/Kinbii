import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kinbii/theme/app_theme.dart';

class ManageStorageScreen extends StatefulWidget {
  const ManageStorageScreen({super.key});

  @override
  State<ManageStorageScreen> createState() => _ManageStorageScreenState();
}

class _ManageStorageScreenState extends State<ManageStorageScreen> {
  final _storageController = TextEditingController();
  List<String> _storages = ['Storage A', 'Storage B', 'Storage C'];

  void _addStorage() {
    if (_storageController.text.isNotEmpty) {
      setState(() {
        _storages.add(_storageController.text);
        _storageController.clear();
      });
    }
  }

  void _showEditDeleteBottomSheet(BuildContext context, int index) {
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
                  _showEditDialog(index);
                },
              ),
              ListTile(
                leading: Icon(Icons.delete, color: AppTheme.appColors.danger),
                title: Text('Delete', style: AppTheme.appTextStyles.bodyLarge),
                onTap: () {
                  setState(() {
                    _storages.removeAt(index);
                  });
                  context.pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showEditDialog(int index) {
    final editController = TextEditingController(text: _storages[index]);
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
                  setState(() {
                    _storages[index] = editController.text;
                  });
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
            Padding(
              padding: EdgeInsets.all(20.w),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _storageController,
                      decoration: InputDecoration(
                        hintText: 'Storage Name',
                        hintStyle: AppTheme.appTextStyles.bodyMedium.copyWith(
                          color: AppTheme.appColors.grey,
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(color: AppTheme.appColors.softGrey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(color: AppTheme.appColors.primary),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  ElevatedButton(
                    onPressed: _addStorage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.appColors.primary,
                      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      'Add',
                      style: AppTheme.appTextStyles.bodyLarge.copyWith(
                        color: AppTheme.appColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                itemCount: _storages.length,
                separatorBuilder: (context, index) => SizedBox(height: 12.h),
                itemBuilder: (context, index) {
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
                        _storages[index],
                        style: AppTheme.appTextStyles.header3,
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.more_vert, color: AppTheme.appColors.grey),
                        onPressed: () => _showEditDeleteBottomSheet(context, index),
                      ),
                      onTap: () => _showEditDeleteBottomSheet(context, index),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

