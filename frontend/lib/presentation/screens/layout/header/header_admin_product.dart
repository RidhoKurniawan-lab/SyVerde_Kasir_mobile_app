import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/constants/app_color.dart';
import 'package:frontend/presentation/screens/layout/header/header_base.dart';
import 'package:frontend/state/auth/auth_provider.dart';

class HeaderAdminProduct extends ConsumerWidget implements PreferredSizeWidget {
  const HeaderAdminProduct({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    if (authState is! AuthSuccess) return const CircularProgressIndicator();

    final user = authState.user;

    return HeaderBase(
      child: Row(
        children: [
          const SizedBox(width: 14),
          
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Management Product',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColor.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              
              Text('${user.name} - ${user.role.name}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColor.primary,
                  fontWeight: FontWeight.w100,
                ),
              ),
            ],
          ),

          const Spacer(),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.category_outlined,
              color: AppColor.primary,
              size: 30,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.move_to_inbox_outlined,
              color: AppColor.primary,
              size: 30,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.add,
              color: AppColor.primary,
              size: 30,
            ),
          ),
        ]
      )
    );
  }
}