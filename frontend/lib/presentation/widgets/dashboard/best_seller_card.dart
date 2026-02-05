import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_color.dart';
import 'package:frontend/data/models/response/best_seller_model.dart';

class BestSellerProductCard extends StatelessWidget {
  final List<BestSeller> products;
  final String periodLabel;

  const BestSellerProductCard({super.key, required this.products, this.periodLabel = 'Today'});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.secondarywhite,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColor.black10,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Top 5 Best Selling Products ($periodLabel)',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          if (products.isEmpty)
            const Center(child: Text('No sales today'))
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: products.length,
              separatorBuilder: (context, index) => const Divider(height: 20),
              itemBuilder: (context, index) {
                final product = products[index];
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: _getRankColor(index),
                          radius: 12,
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          product.productName,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    Text(
                      '${product.totalQty} sold',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColor.blue100,
                      ),
                    ),
                  ],
                );
              },
            ),
        ],
      ),
    );
  }

  Color _getRankColor(int index) {
    switch (index) {
      case 0: return Colors.orange;
      case 1: return Colors.grey.shade400;
      case 2: return Colors.brown.shade300;
      default: return Colors.blueGrey.shade200;
    }
  }
}
