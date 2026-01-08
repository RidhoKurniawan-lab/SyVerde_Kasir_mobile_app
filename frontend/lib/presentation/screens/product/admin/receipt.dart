import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/constants/app_color.dart';
import 'package:frontend/data/models/response/product_model.dart';
import 'package:frontend/presentation/screens/layout/header/header_admin_product.dart';
import 'package:frontend/presentation/widgets/common/card_receipt.dart';
import 'package:frontend/presentation/widgets/common/custom_search_dropdown.dart';
import 'package:frontend/state/receipt_provider.dart';
import 'package:frontend/state/product_provider.dart';
import 'package:frontend/presentation/widgets/common/button_submit_bottom.dart';

class Receipt extends ConsumerStatefulWidget {
  const Receipt({super.key});

  @override
  ConsumerState<Receipt> createState() => _ReceiptState();
}

class _ReceiptState extends ConsumerState<Receipt> {
  late final ProviderSubscription _productSubmitListener;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(productQueryProvider.notifier).getProduct();
    });

    _productSubmitListener = ref.listenManual<ProductSubmitState>(
      productSubmitProvider,
      (prev, next) {
        if (next is ProductSubmitSuccess && mounted) {
          ref.read(productQueryProvider.notifier).getProduct();
          Navigator.pop(context);
        }
      },
    );
  }

  @override
  void dispose() {
    _productSubmitListener.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(productQueryProvider);
    final stateStock = ref.watch(productSubmitProvider);
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
        bottomNavigationBar: BottomSubmitButton(
          text: stateStock is ProductSubmitLoading ? 'Loading...' : 'Save',
          onPressed: stateStock is ProductSubmitLoading
              ? null
              : () {
                  final payload = ref
                      .read(receiptProvider.notifier)
                      .buildPayload();
                  ref
                      .read(productSubmitProvider.notifier)
                      .updateBulkStock(payload);

                  ref.read(receiptProvider.notifier).reset();
                },
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
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
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
                        .addProduct(id: product.id!, name: product.name);
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
                      id: item.id,
                      name: item.name,
                      currentStock: item.stock,
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
