import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_color.dart';
import 'package:frontend/core/configs/routes.dart';
import 'package:frontend/presentation/widgets/helper/Alern.dart';
import 'package:frontend/state/product_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/state/cart_provider.dart';

class CardProductUser extends ConsumerWidget {
  final int id;
  final String name;
  final String category;
  final double price;
  final int stock;
  final String sku;
  final String image;
  final String unit;

  const CardProductUser({
    super.key,
    required this.id,
    required this.category,
    required this.name,
    required this.price,
    required this.stock,
    required this.sku,
    required this.image,
    required this.unit,
  });

  Widget _errorImage() {
    return Container(
      width: 100,
      height: 100,
      color: AppColor.black10,
      child: const Icon(
        Icons.image_not_supported,
        size: 50,
        color: AppColor.black50,
      ),
    );
  }

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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //Image
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: image != 'default' && image.isNotEmpty ? Image.network(
              image,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => _errorImage()
            ) : _errorImage()
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColor.primary,
                  ),
                ),

                const SizedBox(height: 8),
                Text(
                  category,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColor.primary,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const SizedBox(height: 10),

                Text(price.toString(), style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),),

                const SizedBox(height: 10),
              ],
            ),
          ),
              GestureDetector(
                onTap: () {
                  ref.read(cartProvider.notifier).addItem(productId: id, name: name, price: price);
                },
                child: Container(
                  width: 50,
                  height: 50,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColor.green28,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.shopping_basket,
                      color: AppColor.green100,
                      size: 36,
                    ),
                  ),
                ),
              ),
            ],
      ),
    );
  }
}
