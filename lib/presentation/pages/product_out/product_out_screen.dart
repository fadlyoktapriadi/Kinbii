import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:kinbii/theme/app_theme.dart';
import 'package:kinbii/di/injection.dart';
import 'package:kinbii/data/models/product_model.dart';
import 'package:kinbii/data/models/product_movement_model.dart';
import 'package:kinbii/presentation/controllers/product_controller.dart';
import 'package:kinbii/presentation/controllers/report_controller.dart';

class ProductOutScreen extends StatefulWidget {
  const ProductOutScreen({super.key});

  @override
  State<ProductOutScreen> createState() => _ProductOutScreenState();
}

class _ProductOutScreenState extends State<ProductOutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _productNameController = TextEditingController();
  final _stockOutController = TextEditingController();
  final _dateController = TextEditingController();

  final ProductController productController = Get.put(sl<ProductController>());
  final ReportController reportController = Get.put(sl<ReportController>());

  ProductModel? _selectedProduct;

  @override
  void initState() {
    super.initState();
    productController.fetchProducts();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _stockOutController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Product Out',
                  style: AppTheme.appTextStyles.header2,
                ),
                SizedBox(height: 24.h),
                _buildProductSearchField(),
                SizedBox(height: 16.h),
                _buildTextField(
                  label: 'Stock Out',
                  controller: _stockOutController,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 16.h),
                _buildTextField(
                  label: 'Date Out',
                  controller: _dateController,
                  readOnly: true,
                  onTap: () => _selectDate(context),
                  suffixIcon: Icon(Icons.calendar_today, color: AppTheme.appColors.primary),
                ),
                SizedBox(height: 32.h),
                SizedBox(
                  width: double.infinity,
                  height: 50.h,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        if (_selectedProduct != null) {
                          final int stockOut = int.tryParse(_stockOutController.text) ?? 0;
                          final int newStock = (_selectedProduct!.stock - stockOut) < 0
                              ? 0
                              : (_selectedProduct!.stock - stockOut);

                          final int index = productController.products
                              .indexWhere((p) => p.id == _selectedProduct!.id);
                          if (index != -1) {
                            await productController.updateProduct(
                              index,
                              _selectedProduct!.copyWith(stock: newStock),
                            );
                            await reportController.addMovement(
                              ProductMovementModel(
                                productId: _selectedProduct!.id ?? 0,
                                productName: _selectedProduct!.name,
                                categoryName: _selectedProduct!.categoryName,
                                storageName: _selectedProduct!.storageName,
                                quantity: stockOut,
                                type: 'OUT',
                                date: _dateController.text,
                              ),
                            );
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Product stock updated successfully!')),
                              );
                            }
                            _productNameController.clear();
                            _stockOutController.clear();
                            _dateController.clear();
                            setState(() {
                              _selectedProduct = null;
                            });
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please select a valid product')),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.appColors.danger,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      'Submit',
                      style: AppTheme.appTextStyles.bodyLarge.copyWith(
                        color: AppTheme.appColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductSearchField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Product',
          style: AppTheme.appTextStyles.bodyMedium,
        ),
        SizedBox(height: 8.h),
        TypeAheadField<ProductModel>(
          controller: _productNameController,
          builder: (context, controller, focusNode) {
            return TextFormField(
              controller: controller,
              focusNode: focusNode,
              decoration: InputDecoration(
                hintText: 'Search Product',
                hintStyle: AppTheme.appTextStyles.bodyMedium.copyWith(
                  color: AppTheme.appColors.grey,
                ),
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
              ),
              onChanged: (value) {
                if (_selectedProduct?.name != value) {
                  setState(() {
                    _selectedProduct = null;
                  });
                }
              },
              validator: (val) {
                if (val == null || val.isEmpty) {
                  return 'Please select a product';
                }
                if (_selectedProduct == null || _selectedProduct!.name != val) {
                  return 'Please select a valid product from the list';
                }
                return null;
              },
            );
          },
          suggestionsCallback: (pattern) {
            return productController.products
                .where((product) => product.name.toLowerCase().contains(pattern.toLowerCase()))
                .toList();
          },
          itemBuilder: (context, ProductModel suggestion) {
            return ListTile(
              title: Text(suggestion.name, style: AppTheme.appTextStyles.bodyLarge),
              subtitle: Text(
                'Category: ${suggestion.categoryName} • Stock: ${suggestion.stock}',
                style: AppTheme.appTextStyles.bodySmall,
              ),
            );
          },
          onSelected: (ProductModel suggestion) {
            setState(() {
              _selectedProduct = suggestion;
            });
            _productNameController.text = suggestion.name;
          },
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    TextEditingController? controller,
    bool readOnly = false,
    VoidCallback? onTap,
    Widget? suffixIcon,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTheme.appTextStyles.bodyMedium,
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: controller,
          readOnly: readOnly,
          onTap: onTap,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: 'Enter $label',
            hintStyle: AppTheme.appTextStyles.bodyMedium.copyWith(
              color: AppTheme.appColors.grey,
            ),
            suffixIcon: suffixIcon,
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
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter $label';
            }
            if (label == 'Stock Out') {
              final parsed = int.tryParse(value) ?? 0;
              if (parsed <= 0) {
                return 'Stock Out must be greater than 0';
              }
            }
            return null;
          },
        ),
      ],
    );
  }
}
