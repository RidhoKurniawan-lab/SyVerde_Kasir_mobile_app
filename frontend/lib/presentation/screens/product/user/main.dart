import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/constants/app_color.dart';
import 'package:frontend/presentation/screens/layout/header/header_kasir.dart';
import 'package:frontend/state/cart_provider.dart';
import 'package:frontend/state/product_provider.dart';
import 'package:frontend/presentation/widgets/common/card_product_user.dart';
import 'package:frontend/presentation/widgets/common/primary_button.dart';
import 'dart:async';
import 'package:frontend/data/models/response/product_model.dart';

class UserProduct extends ConsumerStatefulWidget {
  const UserProduct({super.key});

  @override
  ConsumerState<UserProduct> createState() => _ProductState();
}

class _ProductState extends ConsumerState<UserProduct> {
  String _searchQuery = '';
  Timer? _debounce;

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
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      setState(() {
        _searchQuery = query;
      });
      ref.read(productSearchProvider.notifier).search(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    final productState = ref.watch(productQueryProvider);
    final searchState = ref.watch(productSearchProvider);
    final cart = ref.watch(cartProvider);
    final totalQty = ref.watch(cartProvider.notifier).totalQty;

    return Scaffold(
      backgroundColor: AppColor.primarywhite,
      appBar: HeaderKasir(
        search: true,
        onSearchChanged: _onSearchChanged,
      ),
      body: _buildBody(productState, searchState),
    );
  }

  Widget _buildBody(ProductQueryState productState, AsyncValue<List<ProductModel>> searchState) {
    if (_searchQuery.isNotEmpty) {
      return searchState.when(
        data: (products) => _buildProductList(products),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      );
    }

    if (productState is ProductQueryLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (productState is ProductQueryLoaded) {
      return _buildProductList(productState.products);
    } else if (productState is ProductQueryError) {
      return Center(child: Text(productState.message));
    }
    return const SizedBox();
  }

  Widget _buildProductList(List<ProductModel> products) {
    final cart = ref.watch(cartProvider);
    final totalQty = ref.watch(cartProvider.notifier).totalQty;

    if (products.isEmpty) {
      return const Center(child: Text('No products found'));
    }

    return Stack(
      children: [
        ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
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
                    const SizedBox(width: 5),
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
    );
  }
}
