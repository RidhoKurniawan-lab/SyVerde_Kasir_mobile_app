import 'package:flutter/material.dart';
import 'package:frontend/presentation/screens/auth/login_screen.dart';
import 'package:frontend/presentation/screens/layout/admin.dart';
import 'package:frontend/presentation/screens/layout/kasir.dart';
import 'package:frontend/presentation/screens/product/admin/add.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String admin = '/admin';
  static const String kasir = '/kasir';
  static const String addProduct = '/add_product';

  static Map<String, WidgetBuilder> getAllRoutes() {
    return {
      login: (context) => const LoginScreen(),
      admin: (context) => const AdminLayout(),
      kasir: (context) => const KasirLayout(),
      addProduct: (context) => AddProduct(),
    };
  }
}