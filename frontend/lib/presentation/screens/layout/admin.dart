import 'package:flutter/material.dart';
import 'package:frontend/presentation/screens/home/admin.dart';
import 'package:frontend/presentation/screens/product/admin/main.dart';
import 'package:frontend/presentation/widgets/navigation/admin_navbar.dart';

class AdminLayout extends StatefulWidget {
  const AdminLayout({super.key});
  
  @override
  State<AdminLayout> createState() => _AdminLayoutState();
}

class _AdminLayoutState extends State<AdminLayout> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    AdminHome(),
    Center(child: Text('Admin Report Page')),
    AdminProduct(),
    Center(child: Text('Admin Transaction Page')),
    Center(child: Text('Admin More Page')),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: AdminNavbar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
