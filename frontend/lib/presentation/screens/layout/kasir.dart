import 'package:flutter/material.dart';
import 'package:frontend/presentation/screens/dashboard/kasir.dart';
import 'package:frontend/presentation/screens/more/transaction.dart';
import 'package:frontend/presentation/screens/product/admin/logout.dart';
import 'package:frontend/presentation/screens/product/user/main.dart';
import 'package:frontend/presentation/widgets/navigation/kasir_navbar.dart';
import 'package:frontend/presentation/screens/more/more.dart';

class KasirLayout extends StatefulWidget {
  const KasirLayout({super.key});
  
  @override
  State<KasirLayout> createState() => _KasirLayoutState();
}

class _KasirLayoutState extends State<KasirLayout> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    KasirDashboard(),
    UserProduct(),
    Transaction(),
    LogoutPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      extendBody: true,
      bottomNavigationBar: KasirNavbar(
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