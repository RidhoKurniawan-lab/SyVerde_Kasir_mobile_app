import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_color.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool withicon;
  final String hintText;
  final IconData? prefixIcon;
  final TextInputType keyboardType;
  final bool obscureText;
  final String? errorText;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.withicon,
    required this.hintText,
    this.prefixIcon,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.errorText
  });

  OutlineInputBorder _border(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelText: label,
        hintText: hintText,
        prefixIcon: withicon ? Icon(prefixIcon) : null,
        filled: true,
        fillColor: AppColor.secondarywhite,

        // HINT / NORMAL
        enabledBorder: _border(AppColor.primary, width: 0.2),

        // FOCUS
        focusedBorder: _border(AppColor.primary, width: 2),

        // ERROR
        errorBorder: _border(Colors.red),
        focusedErrorBorder: _border(Colors.red, width: 2),
      ),
    );
  }
}
