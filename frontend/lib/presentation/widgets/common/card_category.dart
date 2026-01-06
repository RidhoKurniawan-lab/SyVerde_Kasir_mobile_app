import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/constants/app_color.dart';
import 'package:frontend/presentation/widgets/helper/alern.dart';
import 'package:frontend/state/category_provider.dart';
import 'package:frontend/presentation/widgets/helper/add_category.dart';
import 'package:frontend/data/models/response/category_model.dart';

class CardCategory extends ConsumerWidget {
  final int id;
  final String name;

  const CardCategory({super.key, required this.id, required this.name});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColor.secondarywhite,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: AppColor.shadow,
            blurRadius: 5,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: TextStyle(
              color: AppColor.primary,
              fontWeight: FontWeight.w500,
              fontSize: 20,
            ),
          ),
          const SizedBox(width: 20),
          Row(
            children: [
              GestureDetector(
                onTap: () async {
                  final category = await ref.read(categoryProvider.notifier).getCategoryById(id: id);
                  AddItemModal.show(
                    context: context,
                    initialName: category.name,
                    title: 'Edit Category',
                    onSubmit: (name) async {
                      await ref
                          .read(categorySubmitProvider.notifier)
                          .updateCategory(request: CategoryModel(name: name), id: id);

                      await ref
                          .read(categoryQueryProvider.notifier)
                          .getCategory();
                    },
                  );
                },
                child: Container(
                  width: 38,
                  height: 38,
                  margin: const EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColor.blue28,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.edit_square,
                      color: AppColor.blue100,
                      size: 19,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  final confirm = await showDeleteConfirmationDialog(
                    context,
                    itemName: name,
                  );
                  if (confirm == true) {
                    await ref
                        .read(categorySubmitProvider.notifier)
                        .deleteCategory(id: id);
                    await ref
                        .read(categoryQueryProvider.notifier)
                        .getCategory();
                  }
                },
                child: Container(
                  width: 38,
                  height: 38,
                  margin: const EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColor.red28,
                  ),
                  child: const Center(
                    child: Icon(Icons.delete, color: AppColor.red100, size: 22),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
