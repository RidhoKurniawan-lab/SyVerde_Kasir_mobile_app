import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_color.dart';
import 'package:frontend/presentation/widgets/common/card_product_cart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/state/cart_provider.dart';

class ListCheckout extends ConsumerStatefulWidget {
  const ListCheckout({super.key});

  @override
  ConsumerState<ListCheckout> createState() => _ListCheckoutState();
}

class _ListCheckoutState extends ConsumerState<ListCheckout> {

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartProvider);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppColor.primarywhite,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(46),
          topRight: Radius.circular(46),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            children: [
              const SizedBox(height: 14),

              Container(
                width: 400,
                decoration: BoxDecoration(
                  color: AppColor.shadow,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 14),

                    Text(
                      'Order List',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 2),

                    Divider(
                      color: AppColor.primary,
                      thickness: 0.8,
                      indent: 20,
                      endIndent: 20,
                    ),

                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: cart.map((item) {
                        return Flexible(
                          fit: FlexFit.loose,
                          child: CardProductCart(
                            id: item.productId,
                            name: item.name,
                            price: item.price,
                            image: 'default',
                            qty: item.qty,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
