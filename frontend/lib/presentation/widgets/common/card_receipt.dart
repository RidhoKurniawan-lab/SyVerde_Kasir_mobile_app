import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/constants/app_color.dart';
import 'package:frontend/state/receipt_provider.dart';
// import 'package:frontend/presentation/widgets/helper/alern.dart';
// import 'package:frontend/state/category_provider.dart';
// import 'package:frontend/presentation/widgets/helper/add_category.dart';
// import 'package:frontend/data/models/response/category_model.dart';

class CardReceipt extends ConsumerWidget {
  final int id;
  final String name;
  final int currentStock;

  const CardReceipt({super.key, required this.id, required this.name, required this.currentStock});

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
                onTap: () {
                  ref.read(receiptProvider.notifier).decrease(id);
                },
                child: Container(
                  width: 26,
                  height: 26,
                  margin: const EdgeInsets.only(right: 7),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColor.red28,
                  ),
                  child: const Center(
                    child: Icon(Icons.remove, color: AppColor.red100, size: 18),
                  ),
                ),
              ),

              Text(
                currentStock.toString(),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),

              GestureDetector(
                onTap: () {
                  ref.read(receiptProvider.notifier).increase(id);
                },
                child: Container(
                  width: 26,
                  height: 26,
                  margin: const EdgeInsets.only(left: 7),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColor.green28,
                  ),
                  child: const Center(
                    child: Icon(Icons.add, color: AppColor.green100, size: 18),
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
