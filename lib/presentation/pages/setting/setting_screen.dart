import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kinbii/theme/app_theme.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Settings',
                style: AppTheme.appTextStyles.header1,
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
                  // Navigate to Report Product
                },
              ),
              SizedBox(height: 16.h),
              _buildSettingItem(
                context,
                icon: Icons.backup_outlined,
                title: 'Backup Data',
                subtitle: 'Export data to local storage',
                onTap: () {
                  // Handle backup logic
                },
              ),
            ],
          ),
        ),
      ),
    );
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
