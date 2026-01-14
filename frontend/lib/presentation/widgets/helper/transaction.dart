import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_color.dart';

Future<bool?> showSuccessConfirmationDialog(BuildContext context, {String? change}) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false, // false biar user harus pilih
    builder: (context) => AlertDialog(
      title: const Text('Transaction Succees'),
      content: Text('Kembalian ${change ?? "Terimakasih Sudah belanja"}?'),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true), // confirm
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.red100,
          ),
          child: const Text('Delete', style: TextStyle(color: AppColor.black100),),
        ),
      ],
    ),
  );
}
