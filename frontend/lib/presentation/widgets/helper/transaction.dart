import 'package:flutter/material.dart';
import 'package:frontend/presentation/widgets/common/primary_button.dart';

Future<bool?> showSuccessConfirmationDialog(BuildContext context, {String? change}) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false, // false biar user harus pilih
    builder: (context) => AlertDialog(
      title: const Text('Transaction Succees'),
      content: Text('Kembalian ${change ?? "Terimakasih Sudah belanja"}?'),
      actions: [
        PrimaryButton(
          text: 'Delete',
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ],
    ),
  );
}

Future<bool?> showSimpleSuccessDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      title: const Text('Success'),
      content: const Text('Transaction completed successfully.'),
      actions: [
        PrimaryButton(
          text: 'OK',
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ],
    ),
  );
}
