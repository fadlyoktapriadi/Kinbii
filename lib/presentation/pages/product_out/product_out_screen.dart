import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kinbii/theme/app_theme.dart';

class ProductOutScreen extends StatefulWidget {
  const ProductOutScreen({super.key});

  @override
  State<ProductOutScreen> createState() => _ProductOutScreenState();
}

class _ProductOutScreenState extends State<ProductOutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();

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
                  style: AppTheme.appTextStyles.header1,
                ),
                SizedBox(height: 24.h),
                _buildTextField(label: 'Product Name'),
                SizedBox(height: 16.h),
                _buildTextField(label: 'Category'),
                SizedBox(height: 16.h),
                _buildTextField(label: 'Storage Name'),
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
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Submit logic here
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

  Widget _buildTextField({
    required String label,
    TextEditingController? controller,
    bool readOnly = false,
    VoidCallback? onTap,
    Widget? suffixIcon,
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
            return null;
          },
        ),
      ],
    );
  }
}
