import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_color.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/state/cart_provider.dart';

class CardProductCart extends ConsumerWidget {
  final int id;
  final String name;
  final double price;
  final int qty;
  final String image;

  const CardProductCart({
    super.key,
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.qty,
  });

  Widget _errorImage() {
    return Container(
      width: 66,
      height: 66,
      color: AppColor.black10,
      child: const Icon(
        Icons.image_not_supported,
        size: 30,
        color: AppColor.black50,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      padding: const EdgeInsets.only(left: 7, right: 5, top: 5, bottom: 5),
      decoration: BoxDecoration(
        color: AppColor.secondarywhite,
        borderRadius: BorderRadius.circular(20),
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
            child: image != 'default' && image.isNotEmpty
                ? Image.network(
                    image,
                    width: 66,
                    height: 66,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => _errorImage(),
                  )
                : _errorImage(),
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

                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      price.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 10),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            ref.read(cartProvider.notifier).decreaseQty(id);
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
                              child: Icon(
                                Icons.remove,
                                color: AppColor.red100,
                                size: 18,
                              ),
                            ),
                          ),
                        ),

                        Text(qty.toString(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),),

                        GestureDetector(
                          onTap: () {
                            ref.read(cartProvider.notifier).increaseQty(id);
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
                              child: Icon(
                                Icons.add,
                                color: AppColor.green100,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
