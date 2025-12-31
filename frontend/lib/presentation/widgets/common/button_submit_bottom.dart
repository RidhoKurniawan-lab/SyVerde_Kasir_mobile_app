import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_color.dart';

class BottomSubmitButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;

  const BottomSubmitButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 14), 
        child: SizedBox(
          width: double.infinity,
          height: 70,
          child: ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(AppColor.primary),
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
              ),
            ),
            child: Text(
                    text,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: AppColor.primarywhite
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
