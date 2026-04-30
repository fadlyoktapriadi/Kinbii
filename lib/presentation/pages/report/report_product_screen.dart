import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kinbii/di/injection.dart';
import 'package:kinbii/presentation/controllers/product_controller.dart';
import 'package:kinbii/presentation/controllers/report_controller.dart';
import 'package:kinbii/theme/app_theme.dart';

class ReportProductScreen extends StatelessWidget {
  final ProductController productController = Get.put(sl<ProductController>());
  final ReportController reportController = Get.put(sl<ReportController>());

  ReportProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    productController.fetchProducts();
    reportController.fetchMovements();

    return Scaffold(
      appBar: AppBar(
        title: Text('Report Product', style: AppTheme.appTextStyles.header2),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download_outlined),
            onPressed: () => _exportCsv(context),
          ),
        ],
      ),
      body: SafeArea(
        child: Obx(() {
          final totalStock = productController.products
              .fold(0, (sum, item) => sum + item.stock);
          final totalProducts = productController.products.length;

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSummaryGrid(
                  totalProducts: totalProducts,
                  totalStock: totalStock,
                  totalIn: reportController.totalIn,
                  totalOut: reportController.totalOut,
                ),
                SizedBox(height: 24.h),
                Text('Stock Available', style: AppTheme.appTextStyles.header2),
                SizedBox(height: 12.h),
                _buildStockList(),
                SizedBox(height: 24.h),
                Text('Product In', style: AppTheme.appTextStyles.header2),
                SizedBox(height: 12.h),
                _buildMovementList(reportController.inMovements),
                SizedBox(height: 24.h),
                Text('Product Out', style: AppTheme.appTextStyles.header2),
                SizedBox(height: 12.h),
                _buildMovementList(reportController.outMovements),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSummaryGrid({
    required int totalProducts,
    required int totalStock,
    required int totalIn,
    required int totalOut,
  }) {
    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            title: 'Products',
            value: totalProducts.toString(),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _buildSummaryCard(
            title: 'Stock',
            value: totalStock.toString(),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _buildSummaryCard(
            title: 'In / Out',
            value: '${totalIn}/${totalOut}',
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard({required String title, required String value}) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppTheme.appColors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: AppTheme.appColors.softGrey.withValues(alpha: 0.3),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(
          color: AppTheme.appColors.softGrey.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTheme.appTextStyles.bodySmall),
          SizedBox(height: 6.h),
          Text(value, style: AppTheme.appTextStyles.header3),
        ],
      ),
    );
  }

  Widget _buildStockList() {
    return Obx(() {
      if (productController.products.isEmpty) {
        return Text('No products found', style: AppTheme.appTextStyles.bodyMedium);
      }
      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: productController.products.length,
        separatorBuilder: (_, __) => SizedBox(height: 12.h),
        itemBuilder: (context, index) {
          final product = productController.products[index];
          return Container(
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(product.name, style: AppTheme.appTextStyles.header3),
                      SizedBox(height: 4.h),
                      Text(
                        '${product.categoryName} • ${product.storageName}',
                        style: AppTheme.appTextStyles.bodySmall.copyWith(
                          color: AppTheme.appColors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  'Stock: ${product.stock}',
                  style: AppTheme.appTextStyles.bodyMedium.copyWith(
                    color: AppTheme.appColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        },
      );
    });
  }

  Widget _buildMovementList(List movements) {
    if (movements.isEmpty) {
      return Text('No data available', style: AppTheme.appTextStyles.bodyMedium);
    }
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: movements.length,
      separatorBuilder: (_, __) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        final movement = movements[index];
        return Container(
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(movement.productName, style: AppTheme.appTextStyles.header3),
              SizedBox(height: 4.h),
              Text(
                '${movement.categoryName} • ${movement.storageName}',
                style: AppTheme.appTextStyles.bodySmall.copyWith(
                  color: AppTheme.appColors.grey,
                ),
              ),
              SizedBox(height: 8.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Qty: ${movement.quantity}', style: AppTheme.appTextStyles.bodyMedium),
                  Text(movement.date, style: AppTheme.appTextStyles.bodySmall),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _exportCsv(BuildContext context) {
    final buffer = StringBuffer();
    buffer.writeln('type,product,category,storage,quantity,date');

    for (final m in reportController.movements) {
      buffer.writeln(
          '${m.type},${m.productName},${m.categoryName},${m.storageName},${m.quantity},${m.date}');
    }

    Clipboard.setData(ClipboardData(text: buffer.toString()));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Report copied as CSV to clipboard')),
    );
  }
}

