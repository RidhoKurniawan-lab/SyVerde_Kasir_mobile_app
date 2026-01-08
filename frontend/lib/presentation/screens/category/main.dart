import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/constants/app_color.dart';
import 'package:frontend/presentation/screens/layout/header/header_admin_product.dart';
import 'package:frontend/presentation/widgets/common/card_category.dart';
import 'package:frontend/state/category_provider.dart';

class AdminCategory extends ConsumerStatefulWidget {
  const AdminCategory({super.key});

  @override
  ConsumerState<AdminCategory> createState() => _CategoryState();
}

class _CategoryState extends ConsumerState<AdminCategory> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = ref.read(categoryQueryProvider);
      if (state is! CategoryQueryLoaded) {
        ref.read(categoryQueryProvider.notifier).getCategory();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final categoryState = ref.watch(categoryQueryProvider);

    return Scaffold(
      backgroundColor: AppColor.primarywhite,
      appBar: const HeaderAdminProduct(
        isIcon: true,
        category: true,
        header: 'Category Product',
      ),
      body: categoryState is CategoryQueryLoading
          ? const Center(child: CircularProgressIndicator())
          : categoryState is CategoryQueryLoaded
          ? ListView.builder(
              itemCount: categoryState.categories.length,
              itemBuilder: (context, index) {
                final category = categoryState.categories[index];
                return CardCategory(
                  id: category.id!,
                  name: category.name,
                );
              },
            )
          : categoryState is CategoryQueryError
          ? Center(child: Text(categoryState.message))
          : const SizedBox(),
    );
  }
}
