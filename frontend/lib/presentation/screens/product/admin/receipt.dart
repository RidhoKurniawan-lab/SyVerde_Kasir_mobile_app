import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/constants/app_color.dart';
import 'package:frontend/data/models/response/product_model.dart';
import 'package:frontend/presentation/screens/layout/header/header_admin_product.dart';
import 'package:frontend/presentation/widgets/common/card_receipt.dart';
import 'package:frontend/presentation/widgets/common/custom_search_dropdown.dart';
import 'package:frontend/state/receipt_provider.dart';
import 'package:frontend/state/product_provider.dart';
import 'package:frontend/data/models/response/reciept_modal.dart';

class Receipt extends ConsumerStatefulWidget {
  const Receipt({super.key});

  @override
  ConsumerState<Receipt> createState() => _ReceiptState();
}

class _ReceiptState extends ConsumerState<Receipt> {
  final products = [
    ProductModel(id: 1, name: 'Apple', sku: 'APL-01', price: 12000, stock: 0),
    ProductModel(id: 2, name: 'Banana', sku: 'BNN-02', price: 8000, stock: 0),
    ProductModel(id: 3, name: 'Milk', sku: 'MLK-03', price: 15000, stock: 0),
  ];
  late final ProviderSubscription _debug;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(productQueryProvider.notifier).getProduct();
    });

    _debug = ref.listenManual<List<StockUpdateItem>>(receiptProvider, (
      _,
      next,
    ) {
      if (!mounted) return;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ref.read(receiptProvider.notifier).debugLog();
      });
    });
  }

  @override
  void dispose() {
    _debug.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(productQueryProvider);
    if (state is ProductQueryLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is ProductQueryError) {
      return Text(state.message);
    }

    if (state is ProductQueryLoaded) {
      final receipt = ref.watch(receiptProvider);
      return Scaffold(
        backgroundColor: AppColor.primarywhite,
        appBar: const HeaderAdminProduct(
          isIcon: false,
          category: false,
          header: 'Management Stock',
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
          
              Container(
                margin: EdgeInsets.symmetric(horizontal: 14),
                child: CustomSearchDropdown<ProductModel>(
                  label: 'Add Product',
                  hintText: 'Search product...',
                  items: state.products,
                  itemAsString: (item) => item.name,
                  itemBuilder: (context, item) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name,
                                style: const TextStyle(fontWeight: FontWeight.w600),
                              ),
                              Text(
                                item.sku,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            'Rp ${item.price}',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    );
                  },
                          
                  onItemSelected: (product) {
                    ref
                        .read(receiptProvider.notifier)
                        .addProduct(productId: product.id!, name: product.name);
                  },
                ),
              ),

              const SizedBox(height: 20),
          
              Column(
                mainAxisSize: MainAxisSize.min,
                children: receipt.map((item) {
                  return Flexible(
                    fit: FlexFit.loose,
                    child: CardReceipt(
                      id: item.productId,
                      name: item.name,
                      currentStock: item.change,
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      );
    }
    return Text('Error');
  }
}
