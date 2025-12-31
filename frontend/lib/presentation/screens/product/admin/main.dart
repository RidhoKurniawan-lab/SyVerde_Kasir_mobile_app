import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/constants/app_color.dart';
import 'package:frontend/presentation/screens/layout/header/header_admin_product.dart';
import 'package:frontend/state/product_provider.dart';
import 'package:frontend/presentation/widgets/common/card_product.dart';

class AdminProduct extends ConsumerStatefulWidget {
  const AdminProduct({super.key});

  @override
  ConsumerState<AdminProduct> createState() => _ProductState();
}

class _ProductState extends ConsumerState<AdminProduct>{


  @override
  void initState(){
    super.initState();
    Future.microtask((){
      ref.read(productProvider.notifier).getProduct();
    });
  }

  @override
  Widget build(BuildContext context) {
    final productState = ref.watch(productProvider);

    return Scaffold(
      backgroundColor: AppColor.primarywhite,
      appBar: const HeaderAdminProduct(isIcon: true, header: 'Management Product'),
      body: productState is ProductLoading
        ? const Center(child: CircularProgressIndicator())
        : productState is ProductLoaded
            ? ListView.builder(
                itemCount: productState.products.length,
                itemBuilder: (context, index) {
                  final product = productState.products[index];
                  return CardProduct(
                    id: product.id,
                    name: product.name,
                    price: product.price,
                    stock: product.stock,
                    category: product.category.name,
                    sku: product.sku,
                    image: product.image,  
                    unit: product.unit.name
                  );
                },
              )
            : productState is ProductError
                ? Center(child: Text(productState.message))
                : const SizedBox(),
    );
  }
}
