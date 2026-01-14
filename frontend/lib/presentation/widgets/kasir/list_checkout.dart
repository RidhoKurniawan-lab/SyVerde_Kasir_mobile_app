import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/core/constants/app_color.dart';
import 'package:frontend/presentation/widgets/common/card_product_cart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/state/cart_provider.dart';
import 'package:frontend/core/utils/currency_rupiah.dart';

class ListCheckout extends ConsumerStatefulWidget {
  const ListCheckout({super.key});

  @override
  ConsumerState<ListCheckout> createState() => _ListCheckoutState();
}

class _ListCheckoutState extends ConsumerState<ListCheckout> {
  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartProvider);
    final subtotal = ref.watch(cartProvider.notifier).total;
    final discount = 0;

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

                    const SizedBox(height: 6),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColor.black10,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Container(
              margin: const EdgeInsets.all(10),
              height: 50,
              decoration: BoxDecoration(
                color: AppColor.secondarywhite,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(
                          top: 5,
                          bottom: 5,
                          left: 5,
                          right: 14,
                        ),
                        height: 40,
                        width: 40,
                        padding: const EdgeInsets.only(left: 2),
                        decoration: BoxDecoration(
                          color: AppColor.primary,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25),
                            bottomLeft: Radius.circular(25),
                            bottomRight: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                        ),
                        child: Icon(
                          Icons.credit_card,
                          color: AppColor.secondarywhite,
                          size: 28,
                        ),
                      ),

                      Text(
                        'Payment Method',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 40,
                      height: 40,
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColor.green28,
                      ),
                      child: const Center(
                        child: RotatedBox(
                          quarterTurns: 2,
                          child: Icon(
                            Icons.arrow_back,
                            color: AppColor.green100,
                            size: 28,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: AppColor.black10,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Price List',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),

                Divider(
                  color: AppColor.primary,
                  thickness: 0.8,
                  indent: 20,
                  endIndent: 20,
                ),

                const SizedBox(height: 2),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Subtotal',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            formatRupiah(subtotal),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Discount',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            formatRupiah(discount),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 5),

                Divider(
                  color: AppColor.primary,
                  thickness: 0.8,
                  indent: 20,
                  endIndent: 20,
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Price',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        formatRupiah(subtotal - discount),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColor.black10,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Container(
              margin: const EdgeInsets.all(10),
              height: 50,
              decoration: BoxDecoration(
                color: AppColor.secondarywhite,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                      top: 5,
                      bottom: 5,
                      left: 5,
                      right: 14,
                    ),
                    height: 40,
                    width: 40,
                    padding: const EdgeInsets.only(left: 2),
                    decoration: BoxDecoration(
                      color: AppColor.primary,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        bottomLeft: Radius.circular(25),
                        bottomRight: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                    ),
                    child: Icon(
                      Icons.attach_money,
                      color: AppColor.secondarywhite,
                      size: 28,
                    ),
                  ),

                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      decoration: const InputDecoration(
                        border: InputBorder.none, 
                        isCollapsed: true,
                        hintText: 'Masukkan nominal',
                      ),
                      onChanged: (value) {
                        ref.read(cartFormProvider.notifier).setPaidAmount(double.tryParse(value) ?? 0);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
