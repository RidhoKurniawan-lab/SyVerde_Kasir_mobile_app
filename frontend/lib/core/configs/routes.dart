import 'package:flutter/material.dart';
import 'package:frontend/presentation/screens/auth/login_screen.dart';
import 'package:frontend/presentation/screens/category/main.dart';
import 'package:frontend/presentation/screens/layout/admin.dart';
import 'package:frontend/presentation/screens/layout/kasir.dart';
import 'package:frontend/presentation/screens/product/admin/add.dart';
import 'package:frontend/presentation/screens/product/admin/edit.dart';
import 'package:frontend/presentation/screens/product/admin/receipt.dart';
import 'package:frontend/presentation/screens/product/user/checkout.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String admin = '/admin';
  static const String kasir = '/kasir';
  static const String addProduct = '/add_product';
  static const String editProduct = '/edit_product';
  static const String category = '/category';
  static const String checkout = '/checkout';
  static const String receipt = '/receipt';

  static Map<String, WidgetBuilder> getAllRoutes() {
    return {
      login: (context) => const LoginScreen(),
      admin: (context) => const AdminLayout(),
      kasir: (context) => const KasirLayout(),
      addProduct: (context) => AddProduct(),
      category: (context) => AdminCategory(),
      checkout: (context) => Checkout(),
      receipt: (context) => Receipt(),
    };
  }

   static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case editProduct:
        final id = settings.arguments as int?;
        if (id == null) return _errorRoute('Product ID missing!');
        return MaterialPageRoute(builder: (_) => EditProduct(id: id));

      default:
        return null;
    }
  }

  static MaterialPageRoute _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        body: Center(child: Text(message)),
      ),
    );
  }
}