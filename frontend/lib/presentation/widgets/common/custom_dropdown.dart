import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_color.dart';

class CustomDropdown<T> extends StatelessWidget {
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final String label;
  final String hintText;
  final bool withIcon;
  final IconData? prefixIcon;
  final ValueChanged<T?> onChanged;
  final String? Function(T?)? validator;
  final String? errorText;

  const CustomDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.label,
    required this.hintText,
    required this.onChanged,
    this.withIcon = false,
    this.prefixIcon,
    this.validator,
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
    return DropdownButtonFormField<T>(
      initialValue: value,
      isExpanded: true,
      items: items,
      onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        prefixIcon: withIcon ? Icon(prefixIcon) : null,
        filled: true,
        fillColor: AppColor.secondarywhite,
        enabledBorder: _border(Colors.grey.shade300),
        focusedBorder: _border(AppColor.primary, width: 2),
        errorBorder: _border(Colors.red),
        focusedErrorBorder: _border(Colors.red, width: 2),
        errorText: errorText 
      ),
      
      icon: const Icon(Icons.keyboard_arrow_down),
      dropdownColor: AppColor.primarywhite,
      borderRadius: BorderRadius.circular(16),
    );
  }
}
