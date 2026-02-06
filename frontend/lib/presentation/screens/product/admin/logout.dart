import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/configs/routes.dart';
import 'package:frontend/presentation/widgets/helper/alern_logout.dart';
import 'package:frontend/state/auth_provider.dart';

class LogoutPage extends ConsumerWidget {
  const LogoutPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future.microtask(() async {
      final confirm = await showLogoutConfirmationDialog(context);
      if (confirm == true) {
        ref.read(authProvider.notifier).logout();
        Navigator.pushNamed(
          context,
          AppRoutes.login,
          arguments: 'Logout Success',
        );
      }
    });

    // Bisa kasih loading atau blank screen sementara
    return Center(child: CircularProgressIndicator());
  }
}
