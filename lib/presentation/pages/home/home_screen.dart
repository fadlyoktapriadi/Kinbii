import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart';
import 'package:kinbii/theme/app_theme.dart';
import 'package:kinbii/di/injection.dart';
import 'package:kinbii/presentation/controllers/category_controller.dart';
import 'package:kinbii/presentation/controllers/product_controller.dart';

class HomeScreen extends StatelessWidget {
  final CategoryController categoryController = Get.put(sl<CategoryController>());
  final ProductController productController = Get.put(sl<ProductController>());

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    productController.fetchProducts();

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
              Text(
                'Inventory Management System',
                style: AppTheme.appTextStyles.bodyMedium,
              ),
              SizedBox(height: 24.h),
              Text(
                'Hi, Kinbii User! 💖',
                style: AppTheme.appTextStyles.appName.copyWith(
                  fontSize: 20.sp,
                  color: AppTheme.appColors.black
                )
              ),
              SizedBox(height: 12.h),
              Text(
                'Category Product',
                style: AppTheme.appTextStyles.header3,
              ),
              SizedBox(height: 16.h),
              Expanded(
                child: Obx(() {
                  if (categoryController.categories.isEmpty) {
                    return Center(child: Text("No categories found", style: AppTheme.appTextStyles.bodyMedium));
                  }
                  return ListView.separated(
                    itemCount: categoryController.categories.length,
                    separatorBuilder: (context, index) => SizedBox(height: 12.h),
                    itemBuilder: (context, index) {
                      final categoryName = categoryController.categories[index].name;
                      final stock = productController.getCountProductByCategory(categoryName);
                      return _buildCategoryItem(context, categoryName, stock);
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryItem(BuildContext context, String categoryName, int stock) {
    return GestureDetector(
      onTap: () {
        context.push('/product-list', extra: categoryName);
      },
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          gradient: LinearGradient(
            colors: [
              AppTheme.appColors.secondary.withValues(alpha: 0.8),
              AppTheme.appColors.secondary.withValues(alpha: 0.6),
              AppTheme.appColors.white.withValues(alpha: 0.8),
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
                  categoryName,
                  style: AppTheme.appTextStyles.header3.copyWith(
                    color: AppTheme.appColors.white,
                  ),
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Text(
                      '$stock',
                      style: AppTheme.appTextStyles.bodyMedium.copyWith(
                        color: AppTheme.appColors.white,
                        fontSize: 22.sp
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      'Product',
                      style: AppTheme.appTextStyles.bodyMedium.copyWith(
                        color: AppTheme.appColors.white,
                        fontSize: 16.sp
                      ),
                    )
                  ],
                )

              ],
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
