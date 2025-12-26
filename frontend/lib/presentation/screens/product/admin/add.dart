import 'package:flutter/material.dart';

class AddProductAdmin extends StatelessWidget {
  const AddProductAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
      ),
      body: const Center(
        child: Text('Add Product Admin Screen'),
      ),
    );
  }
}