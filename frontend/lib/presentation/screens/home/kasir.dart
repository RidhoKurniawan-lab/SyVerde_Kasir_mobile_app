import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/state/auth_provider.dart';

class KasirHome extends ConsumerStatefulWidget{
  const KasirHome({super.key});

@override
ConsumerState<KasirHome> createState() => _KasirHome();

}

class _KasirHome extends ConsumerState<KasirHome> {

  @override
  void initState() {
    super.initState();

    // Pastikan widget sudah build sebelum menampilkan toast
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = ref.read(authProvider);
      if (state is! AuthCheckSuccess) {
        Navigator.pushReplacementNamed(
          context,
          '/login', 
          arguments: 'TokenExpired',
        );
      } 
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Kasir Screen')),
      body: Center(
        child: () {
          if (state is AuthLoading) {
            return const CircularProgressIndicator();
          } else if (state is AuthCheckSuccess) {
            return const Text('Welcome Back!');
          } else if (state is AuthError) {
            return Text('Error: ${state.message}');
          } else {
            return const Text('Please login');
          }
        }(),
      ),
    );
  }
}