import 'package:flutter/material.dart';
import 'package:frontend/presentation/screens/product/user/main.dart';
import 'package:frontend/presentation/widgets/navigation/kasir_navbar.dart';

class KasirLayout extends StatefulWidget {
  const KasirLayout({super.key});
  
  @override
  State<KasirLayout> createState() => _KasirLayoutState();
}

class _KasirLayoutState extends State<KasirLayout> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    Center(child: Text('Home Page')),
    UserProduct(),
    Center(child: Text('Member Page')),
    Center(child: Text('More Page')),
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