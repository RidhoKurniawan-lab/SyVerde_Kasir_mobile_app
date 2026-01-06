import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_color.dart';
import 'package:frontend/presentation/widgets/common/custom_text_field.dart';

class AddItemModal {
  static Future<void> show({
    required BuildContext context, 
    required Function(String name) onSubmit,
    String? initialName,
    required String title,
    }) async {
    final TextEditingController nameController = TextEditingController(text: initialName ?? '');

    return showDialog(
      context: context,
      barrierDismissible: false, 
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColor.primarywhite,
          title: Text(title, style: TextStyle(fontWeight: FontWeight.w300),), 
          content: SizedBox(
            width: 300,
            child: CustomTextField(
                    withicon: false,
                    controller: nameController,
                    label: 'Name',
                    hintText: 'Nama Product',
                  ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); 
              },
              child: const Text('Cancel', style: TextStyle(color: AppColor.primary),),
            ),
            ElevatedButton(
              onPressed: () async {
                final name = nameController.text.trim();
                if (name.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Nama tidak boleh kosong')),
                  );
                  return;
                } else {
                  onSubmit(name); 
                  Navigator.of(context).pop(); 
                }
              },
              child: const Text('Submit', style: TextStyle(color: AppColor.primary),),
            ),
          ],
        );
      },
    );
  }
}
