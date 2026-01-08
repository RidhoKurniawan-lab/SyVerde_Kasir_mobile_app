import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/constants/app_color.dart';
import 'package:frontend/presentation/screens/layout/header/header_admin_product.dart';
import 'package:frontend/state/cart_provider.dart';
import 'package:frontend/state/product_provider.dart';
import 'package:frontend/presentation/widgets/common/card_product_user.dart';
import 'package:frontend/presentation/widgets/common/primary_button.dart';

class UserProduct extends ConsumerStatefulWidget {
  const UserProduct({super.key});

  @override
  ConsumerState<UserProduct> createState() => _ProductState();
}

class _ProductState extends ConsumerState<UserProduct> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = ref.read(productQueryProvider);
      if (state is! ProductQueryLoaded) {
        ref.read(productQueryProvider.notifier).getProduct();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final productState = ref.watch(productQueryProvider);
    final cart = ref.watch(cartProvider);
    final totalQty = ref.watch(cartProvider.notifier).totalQty;

    return Scaffold(
      backgroundColor: AppColor.primarywhite,
      appBar: const HeaderAdminProduct(
        isIcon: true,
        category: false,
        header: 'Management Product',
      ),
      body: productState is ProductQueryLoading
          ? const Center(child: CircularProgressIndicator())
          : productState is ProductQueryLoaded
          ? Stack(
              children: [
                ListView.builder(
                  itemCount: productState.products.length,
                  itemBuilder: (context, index) {
                    final product = productState.products[index];
                    return CardProductUser(
                      id: product.id!,
                      name: product.name,
                      price: product.price,
                      stock: product.stock,
                      category: product.category?.name ?? '',
                      sku: product.sku,
                      image: product.image,
                      unit: product.unit?.name ?? '',
                    );
                  },
                ),

                if (cart.isNotEmpty)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 150),
                      child: SizedBox(
                        width: 320,
                        child: Row(
                          children: [
                            Expanded(
                              child: PrimaryButton(
                                text: 'Checkout $totalQty item',
                                onPressed: () {
                                  Navigator.pushNamed(context, '/checkout');
                                },
                              ),
                            ),

                            const SizedBox(width: 5,),

                            GestureDetector(
                              onTap: () {
                                ref.read(cartProvider.notifier).clear();
                              },
                              child: Container(
                                width: 48,
                                height: 48,
                                margin: const EdgeInsets.only(right: 12),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColor.red28,
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.delete,
                                    color: AppColor.red100,
                                    size: 36,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            )
          : productState is ProductQueryError
          ? Center(child: Text(productState.message))
          : const SizedBox(),
    );
  }
}
