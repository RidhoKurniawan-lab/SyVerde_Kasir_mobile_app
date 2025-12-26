import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_color.dart';

class HeaderBase extends StatelessWidget implements PreferredSizeWidget {
  final Widget child;

  const HeaderBase({super.key, required this.child});

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColor.secondary,
      elevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      title: child,
    );
  }
}