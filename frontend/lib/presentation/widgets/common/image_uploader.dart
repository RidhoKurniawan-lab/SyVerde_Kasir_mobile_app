import 'dart:io';
import 'package:flutter/material.dart';

class ClickableImageBox extends StatelessWidget {
  final File? imageFile;
  final String? imageUrl;
  final VoidCallback onTap;

  const ClickableImageBox({
    super.key,
    required this.onTap,
    this.imageFile,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    ImageProvider? imageProvider;

    if (imageFile != null) {
      imageProvider = FileImage(imageFile!);
    } else if (imageUrl != null) {
      imageProvider = NetworkImage(imageUrl!);
    }

    return InkWell(
      onTap: onTap,
      borderRadius: const BorderRadius.all(Radius.circular(12)),
      child: Container(
        height: 160,
        width: 160,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          image: imageProvider != null
              ? DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: imageProvider == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.image_outlined, size: 40, color: Colors.grey),
                  SizedBox(height: 8),
                  Text(
                    'Tap to upload image',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              )
            : null,
      ),
    );
  }
}
