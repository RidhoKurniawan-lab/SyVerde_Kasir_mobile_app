import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_color.dart';

class KasirNavbar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const KasirNavbar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: SizedBox(
        height: 80,
        child: Container(
          decoration: BoxDecoration(
            color: AppColor.primary,
            borderRadius: BorderRadius.circular(40),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              _NavItem(icon: Icons.home, index: 0, currentIndex: currentIndex, onTap: onTap),
              SizedBox(width: 18),
              _NavItem(icon: Icons.storefront_outlined, index: 1, currentIndex: currentIndex, onTap: onTap),
              SizedBox(width: 18),
              _NavItem(icon: Icons.person, index: 2, currentIndex: currentIndex, onTap: onTap),
              SizedBox(width: 18),
              _NavItem(icon: Icons.settings, index: 3, currentIndex: currentIndex, onTap: onTap),
            ],
          ),
        ),
      ),
    );    
  }
}


class _NavItem extends StatelessWidget {
  final IconData icon;
  final int index;
  final int currentIndex;
  final Function(int) onTap;

  const _NavItem({
    required this.icon,
    required this.index,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = index == currentIndex;

    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        behavior: HitTestBehavior.opaque,
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: isSelected ? AppColor.secondary : AppColor.transparent,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 40,
              color: isSelected ? AppColor.primary : AppColor.secondary,
            ),
          ),
        ),
      ),
    );
  }
}
