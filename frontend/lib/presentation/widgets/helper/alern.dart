import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_color.dart';

Future<bool?> showDeleteConfirmationDialog(BuildContext context, {String? itemName}) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false, // false biar user harus pilih
    builder: (context) => AlertDialog(
      title: const Text('Konfirmasi Delete'),
      content: Text('Apakah kamu yakin ingin menghapus ${itemName ?? "item ini"}?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false), // cancel
          child: const Text('Cencel'),
        ),
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
