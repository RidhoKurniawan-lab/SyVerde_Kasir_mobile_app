import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/constants/app_color.dart';
import 'package:frontend/presentation/screens/layout/header/header_base.dart';
import 'package:frontend/presentation/widgets/common/custom_search.dart';
import 'package:frontend/state/auth_provider.dart';

class HeaderKasir extends ConsumerWidget implements PreferredSizeWidget {
  final bool? chekbox;
  final String? header;
  final bool? isHeaderShow;
  final bool? name;
  final bool? back;
  final bool? filter;
  final bool? search;

  const HeaderKasir({
    super.key,
    this.chekbox,
    this.header,
    this.name,
    this.back,
    this.filter,
    this.isHeaderShow,
    this.search,
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
          if (search == null || search == false) const SizedBox(width: 14),
          if (search ?? false)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: SizedBox(
                  height: 50,
                  child: SearchTextField(
                    onChanged: (value) {},
                  )
                ),
              ),
            ),

          if (back ?? false)
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
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

          if (back ?? false) const SizedBox(width: 10),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isHeaderShow ?? false)
                  Text(
                    header!,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColor.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 24,
                    ),
                  ),
                if (name ?? false)
                  Text(
                    '${user.name} - ${user.role.name}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColor.primary,
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                if (name ?? false) const SizedBox(height: 10),
              ],
            ),
          ),

          if (filter ?? false)
          const Spacer(),
          if (filter ?? false)
            IconButton(
              onPressed: () {},
              icon: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColor.primary,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Icon(
                  Icons.filter_alt_outlined,
                  color: AppColor.secondarywhite,
                  size: 14,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
