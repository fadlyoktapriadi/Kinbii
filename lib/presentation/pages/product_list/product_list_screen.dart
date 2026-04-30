import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart';
import 'package:kinbii/theme/app_theme.dart';
import 'package:kinbii/di/injection.dart';
import 'package:kinbii/data/models/product_model.dart';
import 'package:kinbii/presentation/controllers/product_controller.dart';

class ProductListScreen extends StatefulWidget {
  final String categoryName;

  const ProductListScreen({super.key, required this.categoryName});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final ProductController controller = Get.put(sl<ProductController>());

  @override
  void initState() {
    super.initState();
    controller.fetchProductsByCategory(widget.categoryName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.categoryName,
          style: AppTheme.appTextStyles.header2,
        ),
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
              padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 0),
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: 'Search product...',
                  hintStyle: AppTheme.appTextStyles.bodyMedium.copyWith(
                    color: AppTheme.appColors.grey,
                  ),
                  prefixIcon: Icon(Icons.search, color: AppTheme.appColors.grey),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: AppTheme.appColors.softGrey),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: AppTheme.appColors.softGrey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: AppTheme.appColors.primary),
                  ),
                  filled: true,
                  fillColor: AppTheme.appColors.white,
                ),
              ),
            ),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.categoryProducts.isEmpty) {
                  return Center(child: Text("No products found", style: AppTheme.appTextStyles.bodyMedium));
                }
                return ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                  itemCount: controller.categoryProducts.length,
                  separatorBuilder: (context, index) => SizedBox(height: 12.h),
                  itemBuilder: (context, index) {
                    final product = controller.categoryProducts[index];
                    return _buildProductItem(index, product);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDeleteBottomSheet(BuildContext context, int index, ProductModel product) {
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
                leading: Icon(Icons.edit_note, color: AppTheme.appColors.info),
                title: Text('Edit Stock', style: AppTheme.appTextStyles.bodyLarge),
                onTap: () {
                  context.pop();
                  _showEditStockDialog(index, product);
                },
              ),
              ListTile(
                leading: Icon(Icons.delete, color: AppTheme.appColors.danger),
                title: Text('Delete', style: AppTheme.appTextStyles.bodyLarge),
                onTap: () {
                  if (product.id != null) {
                    controller.deleteProduct(product.id!, index);
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

  void _showEditStockDialog(int index, ProductModel product) {
    final stockController = TextEditingController(text: product.stock.toString());
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
              Text('Edit Stock', style: AppTheme.appTextStyles.header2),
              SizedBox(height: 16.h),
              TextFormField(
                controller: stockController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Stock Quantity',
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
                      if (stockController.text.isNotEmpty) {
                        final newStock = int.tryParse(stockController.text) ?? product.stock;
                        controller.updateProduct(
                          index,
                          product.copyWith(stock: newStock),
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
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProductItem(int index, ProductModel product) {
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
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        product.name,
                        style: AppTheme.appTextStyles.header3,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.more_vert, color: AppTheme.appColors.grey),
                      onPressed: () => _showEditDeleteBottomSheet(context, index, product),
                    ),
                  ],
                ),
                SizedBox(height: 6.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Stok: ${product.stock}',
                      style: AppTheme.appTextStyles.bodyMedium.copyWith(
                        color: AppTheme.appColors.grey,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 16.w,
                          color: AppTheme.appColors.primary,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          product.storageName,
                          style: AppTheme.appTextStyles.bodyMedium.copyWith(
                            color: AppTheme.appColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
