import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/constants/app_color.dart';
import 'package:frontend/presentation/widgets/common/button_submit_bottom.dart';
import 'package:frontend/presentation/widgets/helper/transaction.dart';
import 'package:frontend/presentation/widgets/kasir/list_checkout.dart';
import 'package:frontend/data/models/response/cart_model.dart';
import 'package:frontend/state/cart_provider.dart';
import 'package:frontend/state/product_provider.dart';

class Checkout extends ConsumerStatefulWidget {
  const Checkout({super.key});

  @override
  ConsumerState<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends ConsumerState<Checkout> {
  late final ProviderSubscription _productSubmitListener;
  late final ProviderSubscription _cartSub;
  final _paidAmount = TextEditingController();

  @override
  void initState() {
    super.initState();

    _cartSub = ref.listenManual<List<CartModel>>(cartProvider, (prev, next) {
      if (next.isEmpty) {
        Navigator.pop(context);
      }
    });

    _productSubmitListener = ref.listenManual<ProductSubmitState>(
      productSubmitProvider,
      (prev, next) async {
        if (next is ProductSubmitSuccess && mounted)  {
          final confirm = await showSuccessConfirmationDialog(context, change: (ref.watch(cartFormProvider).paidAmount - ref.watch(cartProvider.notifier).total).toString());
          if (confirm == true) {
          ref.read(productQueryProvider.notifier).getProduct();
          Navigator.pop(context);
          ref.read(cartProvider).clear();
          }
        }
      },
    );
  }

  @override
  void dispose() {
    _cartSub.close();
    _paidAmount.dispose();
    _productSubmitListener.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    final cart = ref.watch(cartFormProvider);
    final state = ref.watch(productSubmitProvider);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColor.primary,
      bottomNavigationBar: Container(
        color: AppColor.primarywhite,
        child: BottomSubmitButton(
          text: state is ProductSubmitLoading ? 'Loading...' : 'Save',
          onPressed: state is ProductSubmitLoading
              ? null
              : () async {
                  if (cart.paidAmount == 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Paid amount cant be empty')),
                    );
                  }
                  final payload = ref
                      .read(cartProvider.notifier)
                      .buildPayload('cash', cart.paidAmount, 0);

                  ref
                      .read(productSubmitProvider.notifier)
                      .insertTransaction(payload);
                },
        ),
      ),
      body: SizedBox.expand(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/Background.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (!isKeyboardOpen) ...[
                            Padding(
                              padding: const EdgeInsets.all(14),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: GestureDetector(
                                  onTap: () => Navigator.pop(context),
                                  child: Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColor.primarylight40,
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.arrow_back,
                                        color: AppColor.primary,
                                        size: 36,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            Text(
                              'Checkout',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.w900,
                                color: AppColor.primarywhite,
                              ),
                            ),

                            const SizedBox(height: 56),
                          ],

                          Expanded(child: ListCheckout()),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
