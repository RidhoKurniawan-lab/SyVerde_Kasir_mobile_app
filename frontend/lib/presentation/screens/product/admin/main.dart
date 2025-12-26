import 'package:flutter/material.dart';
import 'package:frontend/presentation/screens/layout/header/header_admin_product.dart';

class AdminProduct extends StatelessWidget {
  const AdminProduct({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HeaderAdminProduct(),
      body: const Center(
        child: Text('Admin Product Content'),
      ),
    );
  }
}