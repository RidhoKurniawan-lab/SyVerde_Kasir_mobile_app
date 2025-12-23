import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_color.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hintText;
  final IconData prefixIcon;
  final TextInputType keyboardType;
  final bool obscureText;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hintText,
    required this.prefixIcon,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
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
        hintText: hintText,
        prefixIcon: Icon(prefixIcon),
        filled: true,
        fillColor: Colors.grey.shade100,

        // HINT / NORMAL
        enabledBorder: _border(Colors.grey.shade300),

        // FOCUS
        focusedBorder: _border(AppColor.primary, width: 2),

        // ERROR
        errorBorder: _border(Colors.red),
        focusedErrorBorder: _border(Colors.red, width: 2),
      ),
    );
  }
}
