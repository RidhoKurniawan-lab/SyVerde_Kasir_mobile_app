import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/constants/app_color.dart';
import 'package:frontend/presentation/screens/layout/header/header_base.dart';
import 'package:frontend/state/auth_provider.dart';

class HeaderAdminProduct extends ConsumerWidget implements PreferredSizeWidget {
  final bool isIcon;
  final String header;

  const HeaderAdminProduct({
    super.key,
    required this.isIcon,
    required this.header
  });


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

          if(!isIcon)
          GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColor.primarylight40,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.arrow_back,
                      color: AppColor.primary,
                      size: 24,
                    ),
                  ),
                ),
              ),
          
          if (!isIcon) const SizedBox(width: 10),
          
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(header,
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
          if (isIcon)
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.category_outlined,
              color: AppColor.primary,
              size: 30,
            ),
          ),
          if (isIcon)
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.move_to_inbox_outlined,
              color: AppColor.primary,
              size: 30,
            ),
          ),

          // Add Product
          if (isIcon)
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/add_product');
            },
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