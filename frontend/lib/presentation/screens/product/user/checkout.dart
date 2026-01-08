import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/constants/app_color.dart';
import 'package:frontend/presentation/widgets/common/button_submit_bottom.dart';
import 'package:frontend/presentation/widgets/kasir/list_checkout.dart';
import 'package:frontend/data/models/response/cart_model.dart';
import 'package:frontend/state/cart_provider.dart';

class Checkout extends ConsumerStatefulWidget {
  const Checkout({super.key});

  @override
  ConsumerState<Checkout> createState() => _CheckoutState();
  
}

class _CheckoutState extends ConsumerState<Checkout> {
  late final ProviderSubscription _cartSub;

  @override
  void initState() {
    super.initState();

    _cartSub = ref.listenManual<List<CartModel>>(cartProvider,
      (prev, next) {
        if (next.isEmpty) {
          Navigator.pop(context);
        }
      },
    );
  }

  @override
  void dispose() {
    _cartSub.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColor.primary,
      bottomNavigationBar: Container(
        color: AppColor.primarywhite,
        child: BottomSubmitButton(text: 'Save', onPressed: () {}),
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
