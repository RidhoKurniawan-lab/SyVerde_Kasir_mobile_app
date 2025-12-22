//Entry point aplikasi

// Menjalankan runApp()
//Setup awal: theme, route, dependency injection

//Contoh isi:

//MaterialApp
//Initial route (login / home)


import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SyVerde',
      debugShowCheckedModeBanner: false,
      home: Scaffold(),
    );
  }
}
