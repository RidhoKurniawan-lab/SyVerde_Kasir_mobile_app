import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_color.dart';

Future<bool?> showLogoutConfirmationDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false, // user harus pilih salah satu
    builder: (context) => AlertDialog(
      title: const Text('Konfirmasi Logout'),
      content: const Text('Apakah Anda yakin ingin logout dari aplikasi ini?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false), // cancel
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true), // confirm logout
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.red100, // bisa pakai warna merah untuk logout
          ),
          child: const Text(
            'Logout',
            style: TextStyle(color: AppColor.black100),
          ),
        ),
      ],
    ),
  );
}
