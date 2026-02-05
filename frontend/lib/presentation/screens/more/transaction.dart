import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/utils/date_time.dart';
import 'package:frontend/core/constants/app_color.dart';
import 'package:frontend/presentation/screens/layout/header/header_kasir.dart';
import 'package:frontend/presentation/widgets/common/card_transaction.dart';
import 'package:frontend/state/transaction_provider.dart';

class Transaction extends ConsumerStatefulWidget {
  const Transaction({super.key});
  @override
  ConsumerState<Transaction> createState() => _Transaction();
}

class _Transaction extends ConsumerState<Transaction> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = ref.read(transactionQueryProvider);
      
      if (state is! TransactionQueryLoaded) {
        ref.read(transactionQueryProvider.notifier).getTransaction();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(transactionQueryProvider);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        backgroundColor: AppColor.primarywhite,
        title: const HeaderKasir(
          header: 'History Transaction',
          isHeaderShow: true,
          back: true,
        ),
      ),
      backgroundColor: AppColor.primarywhite,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [ 

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    'History Transaction',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (state is TransactionQueryLoaded &&
                              state.currentPage! > 1) {
                            ref
                                .read(transactionQueryProvider.notifier)
                                .getTransaction(page: state.currentPage! - 1);
                          }
                        },
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: AppColor.secondarywhite,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              bottomLeft: Radius.circular(12),
                            ),
                            border: Border.all(
                              color: AppColor.primary,
                              width: 0.5,
                            ),
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Icon(
                                Icons.arrow_back_ios,
                                color: AppColor.primary,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 8),

                      Text(
                        state is TransactionQueryLoading
                            ? state.currentPage.toString()
                            : state is TransactionQueryLoaded
                            ? state.currentPage.toString()
                            : '0',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const SizedBox(width: 8),

                      GestureDetector(
                        onTap: () {
                          if (state is TransactionQueryLoaded) {
                            if (!state.isLastPage) {
                              ref
                                  .read(transactionQueryProvider.notifier)
                                  .getTransaction(page: state.currentPage! + 1);
                            }
                          }
                        },
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: AppColor.secondarywhite,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                            ),
                            border: Border.all(
                              color: AppColor.primary,
                              width: 0.5,
                            ),
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: RotatedBox(
                                quarterTurns: 2,
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  color: AppColor.primary,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 5),

            Expanded(
              child: state is TransactionQueryLoading
                  ? const Center(child: CircularProgressIndicator())
                  : state is TransactionQueryLoaded
                  ? ListView.builder(
                      itemCount: state.transactions.length,
                      itemBuilder: (context, index) {
                        final transaction = state.transactions[index];
                        return TransactionCard(
                          id: transaction.id!,
                          invoice: transaction.invoiceNumber.toString(),
                          date: DateTimeUtils.formatDate(
                            transaction.createdAt.toString(),
                          ),
                          time: DateTimeUtils.formatTime(
                            transaction.createdAt.toString(),
                          ),
                        );
                      },
                    )
                  : state is TransactionQueryError
                  ? Center(child: Text(state.message))
                  : const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}
