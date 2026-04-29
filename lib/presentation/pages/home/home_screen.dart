import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kinbii/theme/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
                'Kinbii',
                style: AppTheme.appTextStyles.appName,
              ),
              SizedBox(height: 24.h),
              Text(
                'Daftar Kategori',
                style: AppTheme.appTextStyles.header2,
              ),
              SizedBox(height: 16.h),
              Expanded(
                child: ListView.separated(
                  itemCount: 5,
                  separatorBuilder: (context, index) => SizedBox(height: 12.h),
                  itemBuilder: (context, index) {
                    return _buildCategoryItem(context, index);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryItem(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        context.push('/product-list', extra: 'Kategori ${index + 1}');
      },
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          gradient: LinearGradient(
            colors: [
              AppTheme.appColors.primary.withValues(alpha: 0.8),
              AppTheme.appColors.info.withValues(alpha: 0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.appColors.softGrey.withValues(alpha: 0.3),
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Kategori ${index + 1}',
                  style: AppTheme.appTextStyles.header3.copyWith(
                    color: AppTheme.appColors.white,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Total Stok: ${(index + 1) * 15}',
                  style: AppTheme.appTextStyles.bodyMedium.copyWith(
                    color: AppTheme.appColors.white,
                  ),
                ),
              ],
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: AppTheme.appColors.white,
              size: 20.w,
            ),
          ],
        ),
      ),
    );
  }
}
