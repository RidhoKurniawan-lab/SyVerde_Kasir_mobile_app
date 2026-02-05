//Entry point aplikasi

// Menjalankan runApp()
//Setup awal: theme, route, dependency injection

//Contoh isi:

//MaterialApp
//Initial route (login / home)
// RI


import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/configs/routes.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
      WidgetsFlutterBinding.ensureInitialized();
    await initializeDateFormatting('en_US', null);
  runApp(const ProviderScope(
      child: MainApp(),
    ),);
}
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      title: 'SyVerde',
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.login,
      routes: AppRoutes.getAllRoutes(),
      onGenerateRoute: AppRoutes.onGenerateRoute,
    );
  }
}
