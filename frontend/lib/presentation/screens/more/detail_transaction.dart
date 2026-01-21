import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/constants/app_color.dart';
import 'package:frontend/core/utils/currency_rupiah.dart';
import 'package:frontend/core/utils/date_time.dart';
import 'package:frontend/presentation/screens/layout/header/header_admin_product.dart';
import 'package:frontend/presentation/screens/layout/header/header_kasir.dart';
import 'package:frontend/state/transaction_provider.dart';

class DetailTransaction extends ConsumerStatefulWidget {
  final int id;
  const DetailTransaction({super.key, required this.id});

  @override
  ConsumerState<DetailTransaction> createState() => _DetailTransaction();
}

class _DetailTransaction extends ConsumerState<DetailTransaction> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = ref.read(transactionProvider);
      if (state is! TransactionLoaded) {
        ref
            .read(transactionProvider.notifier)
            .getTransactionById(id: widget.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(transactionProvider);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        backgroundColor: AppColor.primarywhite,
        title: const HeaderKasir(
          isHeaderShow: true,
          header: 'Detail Transaction',
          back: true,
        ),
      ),
      body: state is TransactionLoading
          ? const Center(child: CircularProgressIndicator())
          : state is TransactionLoaded
          ? Container(
              margin: EdgeInsets.symmetric(horizontal: 14),
              padding: EdgeInsets.only(top: 20),
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColor.secondarywhite,
                  border: Border.all(color: AppColor.green100, width: 0.5),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              "ID Invoice:",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),

                            Text(
                              state.transaction.invoiceNumber.toString(),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColor.green100,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_month,
                              size: 12,
                              color: AppColor.black50,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              DateTimeUtils.formatDateTime(
                                state.transaction.createdAt.toString(),
                              ),
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 5),

                    Divider(
                      color: AppColor.primary,
                      thickness: 0.8,
                      indent: 0,
                      endIndent: 0,
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: Text(
                            'Name of Item',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Qty',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            'Price',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),

                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: (state.transaction.items ?? []).map((item) {
                        return Flexible(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(flex: 5, child: Text(item.product!.name.toString())),
                              Expanded(flex: 2, child: Text(item.qty.toString())),
                              Expanded(flex: 3, child: Text(formatRupiah(item.subtotal))),
                            ],
                          ),
                        );
                      }).toList(),
                    ),

                    Divider(
                      color: AppColor.primary,
                      thickness: 0.8,
                      indent: 0,
                      endIndent: 0,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Price',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          formatRupiah(state.transaction.total!),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 5),

                    Row(
                      children: [
                        Text(
                          'payment method:',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: AppColor.primary,
                          ),
                        ),
                        Text(
                          state.transaction.paymentMethod!,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          : state is TransactionError
          ? Center(child: Text(state.message))
          : const SizedBox(),
    );
  }
}
