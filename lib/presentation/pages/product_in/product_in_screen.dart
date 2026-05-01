import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kinbii/theme/app_theme.dart';
import 'package:kinbii/di/injection.dart';
import 'package:kinbii/data/models/product_model.dart';
import 'package:kinbii/data/models/product_movement_model.dart';
import 'package:kinbii/presentation/controllers/product_controller.dart';
import 'package:kinbii/presentation/controllers/category_controller.dart';
import 'package:kinbii/presentation/controllers/storage_controller.dart';
import 'package:kinbii/presentation/controllers/report_controller.dart';

class ProductInScreen extends StatefulWidget {
  const ProductInScreen({super.key});

  @override
  State<ProductInScreen> createState() => _ProductInScreenState();
}

class _ProductInScreenState extends State<ProductInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _stockController = TextEditingController();
  final _dateController = TextEditingController();

  final ProductController productController =
      Get.isRegistered<ProductController>()
      ? Get.find<ProductController>()
      : Get.put(sl<ProductController>());
  final CategoryController categoryController =
      Get.isRegistered<CategoryController>()
      ? Get.find<CategoryController>()
      : Get.put(sl<CategoryController>());
  final StorageController storageController =
      Get.isRegistered<StorageController>()
      ? Get.find<StorageController>()
      : Get.put(sl<StorageController>());
  final ReportController reportController = Get.isRegistered<ReportController>()
      ? Get.find<ReportController>()
      : Get.put(sl<ReportController>());

  String? _selectedCategory;
  String? _selectedStorage;

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
    _nameController.dispose();
    _stockController.dispose();
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
                Text('Product In', style: AppTheme.appTextStyles.header2),
                SizedBox(height: 24.h),
                _buildTextField(
                  label: 'Product Name',
                  controller: _nameController,
                ),
                SizedBox(height: 16.h),
                _buildTextField(
                  label: 'Stock',
                  controller: _stockController,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 16.h),
                Obx(
                  () => _buildDropdown(
                    label: 'Category',
                    value: _selectedCategory,
                    items: categoryController.categories
                        .map((e) => e.name)
                        .toList(),
                    onChanged: (val) {
                      setState(() {
                        _selectedCategory = val;
                      });
                    },
                  ),
                ),
                SizedBox(height: 16.h),
                Obx(
                  () => _buildDropdown(
                    label: 'Storage',
                    value: _selectedStorage,
                    items: storageController.storages
                        .map((e) => e.name)
                        .toList(),
                    onChanged: (val) {
                      setState(() {
                        _selectedStorage = val;
                      });
                    },
                  ),
                ),
                SizedBox(height: 16.h),
                _buildTextField(
                  label: 'Date In',
                  controller: _dateController,
                  readOnly: true,
                  onTap: () => _selectDate(context),
                  suffixIcon: Icon(
                    Icons.calendar_today,
                    color: AppTheme.appColors.grey,
                  ),
                ),
                SizedBox(height: 32.h),
                SizedBox(
                  width: double.infinity,
                  height: 50.h,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate() &&
                          _selectedCategory != null &&
                          _selectedStorage != null) {
                        final product = ProductModel(
                          name: _nameController.text,
                          categoryName: _selectedCategory!,
                          storageName: _selectedStorage!,
                          stock: int.tryParse(_stockController.text) ?? 0,
                          dateIn: _dateController.text,
                        );

                        final created = await productController.addProduct(
                          product,
                        );
                        if (created != null) {
                          await reportController.addMovement(
                            ProductMovementModel(
                              productId: created.id ?? 0,
                              productName: created.name,
                              categoryName: created.categoryName,
                              storageName: created.storageName,
                              quantity: created.stock,
                              type: 'IN',
                              date: created.dateIn,
                            ),
                          );
                          await productController.fetchProducts();
                        }

                        if (created != null && mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Product added successfully!'),
                            ),
                          );
                          _nameController.clear();
                          _stockController.clear();
                          _dateController.clear();
                          setState(() {
                            _selectedCategory = null;
                            _selectedStorage = null;
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please fill all fields'),
                            ),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.appColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      'Submit',
                      style: AppTheme.appTextStyles.bodyLarge.copyWith(
                        color: AppTheme.appColors.white,
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
        Text(label, style: AppTheme.appTextStyles.bodyMedium),
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
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 12.h,
            ),
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
              borderSide: BorderSide(color: AppTheme.appColors.softGrey),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter $label';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTheme.appTextStyles.bodyMedium),
        SizedBox(height: 8.h),
        DropdownButtonFormField<String>(
          value: value,
          style: AppTheme.appTextStyles.bodyMedium.copyWith(
            color: AppTheme.appColors.black,
          ),
          hint: Text(
            'Select $label',
            style: AppTheme.appTextStyles.bodyMedium.copyWith(
              color: AppTheme.appColors.grey,
            ),
          ),
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: 'Select $label',
            hintStyle: AppTheme.appTextStyles.bodyMedium.copyWith(
              color: AppTheme.appColors.black,
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 12.h,
            ),
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
              borderSide: BorderSide(color: AppTheme.appColors.softGrey),
            ),
          ),
          validator: (val) => val == null ? 'Please select $label' : null,
        ),
      ],
    );
  }
}
