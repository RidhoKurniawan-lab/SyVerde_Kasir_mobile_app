import 'package:flutter/material.dart';

class KasirHome extends StatelessWidget{
  const KasirHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kasir Screen')),
      body: const Center(child: Text('Kasir Home')),
    );
  }
}