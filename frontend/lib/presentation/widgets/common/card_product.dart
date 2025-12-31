import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_color.dart';

class CardProduct extends StatelessWidget {
  final int id;
  final String name;
  final String category;
  final double price;
  final int stock;
  final String sku;
  final String image;
  final String unit;

  const CardProduct({
    super.key,
    required this.id,
    required this.category,
    required this.name,
    required this.price,
    required this.stock,
    required this.sku,
    required this.image,
    required this.unit
  });

  @override
  Widget build(BuildContext context) {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Image
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Image.network(
              image,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                width: 100,
                height: 100,
                color: AppColor.black10,
                child: const Icon(
                Icons.image_not_supported,
                size: 50,
                color: AppColor.black50,
                ),
              ),
            ),
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

                const SizedBox(height: 8),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Price:',
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColor.black100,
                            fontWeight: FontWeight.w100,
                          ),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          price.toString(),
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColor.black100,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(width: 12),

                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Stock:',
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColor.black100,
                            fontWeight: FontWeight.w100,
                          ),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          "$stock  $unit",
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColor.black100,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(width: 12),

                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'SKU:',
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColor.black100,
                            fontWeight: FontWeight.w100,
                          ),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          sku,
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColor.black100,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 10),
              ],
            ),
          ),
          Column(
            children: [
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: 38,
                  height: 38,
                  margin: const EdgeInsets.only(right: 12, top: 8),
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
                onTap: () {},
                child: Container(
                  width: 38,
                  height: 38,
                  margin: const EdgeInsets.only(right: 12, top: 8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColor.red28,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.delete,
                      color: AppColor.red100,
                      size: 22,
                    ),
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
