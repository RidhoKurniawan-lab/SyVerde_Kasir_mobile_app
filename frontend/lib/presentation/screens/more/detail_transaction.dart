import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/constants/app_color.dart';
import 'package:frontend/core/utils/currency_rupiah.dart';
import 'package:frontend/core/utils/date_time.dart';
import 'package:frontend/core/utils/pdf_generator.dart';
import 'package:frontend/presentation/screens/layout/header/header_kasir.dart';
import 'package:frontend/presentation/widgets/common/button_submit_bottom.dart';
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
          ? Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 14),
                      padding: const EdgeInsets.only(top: 20),
                      child: Container(
                        padding: const EdgeInsets.all(16),
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
                                    const Text(
                                      "ID Invoice:",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Text(
                                      state.transaction.invoiceNumber.toString(),
                                      style: const TextStyle(
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
                            const Divider(
                              color: AppColor.primary,
                              thickness: 0.8,
                              indent: 0,
                              endIndent: 0,
                            ),
                            const Row(
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
                            const SizedBox(height: 8),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: (state.transaction.items ?? []).length,
                              itemBuilder: (context, index) {
                                final item = state.transaction.items![index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(flex: 5, child: Text(item.product!.name.toString())),
                                      Expanded(flex: 2, child: Text(item.qty.toString())),
                                      Expanded(flex: 3, child: Text(formatRupiah(item.subtotal))),
                                    ],
                                  ),
                                );
                              },
                            ),
                            const Divider(
                              color: AppColor.primary,
                              thickness: 0.8,
                              indent: 0,
                              endIndent: 0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Total Price',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                Text(
                                  formatRupiah(state.transaction.total!),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Text(
                                  'payment method: ',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: AppColor.primary,
                                  ),
                                ),
                                Text(
                                  state.transaction.paymentMethod?.toLowerCase() == 'qris'
                                      ? 'Non-Tunai'
                                      : 'Cash',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: BottomSubmitButton(
                    text: 'Print Struk',
                    onPressed: () {
                      PdfGenerator.generateReceipt(state.transaction);
                    },
                  ),
                ),
              ],
            )
          : state is TransactionError
          ? Center(child: Text(state.message))
          : const SizedBox(),
    );
  }
}
