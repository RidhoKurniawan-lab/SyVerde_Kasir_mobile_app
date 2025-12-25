import 'package:flutter/material.dart';
import 'package:frontend/presentation/screens/home/admin_screen.dart';
import 'package:frontend/presentation/screens/home/kasir_screen.dart';  
import 'package:frontend/presentation/screens/auth/login_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String admin = '/admin';
  static const String kasir = '/kasir';

  static Map<String, WidgetBuilder> getAllRoutes() {
    return {
      login: (context) => const LoginScreen(),
      admin: (context) => const AdminScreen(),
      kasir: (context) => const KasirScreen(),
    };
  }
}