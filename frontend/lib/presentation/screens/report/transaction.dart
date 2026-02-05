import 'package:flutter/material.dart';
import 'package:frontend/core/utils/currency_rupiah.dart';
import 'package:frontend/core/utils/date_time.dart';
import 'package:frontend/presentation/screens/report/table.dart';
import 'package:frontend/core/constants/app_color.dart';
import 'package:frontend/presentation/screens/layout/header/header_admin_product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/presentation/widgets/common/card_report.dart';
import 'package:frontend/state/transaction_provider.dart';

class TransactionTable extends ConsumerStatefulWidget {
  const TransactionTable({super.key});

  @override
  ConsumerState<TransactionTable> createState() => _TransactionTableState();
}

class _TransactionTableState extends ConsumerState<TransactionTable> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = ref.read(transactionQueryProvider);
      if (state is! TransactionQueryLoaded) {
        ref
            .read(transactionQueryProvider.notifier)
            .getTransaction(page: 1, limit: 10);
      }

      final stateSum = ref.read(transactionProvider);
      if (stateSum is! TransactionLoadedSummery) {
        ref.read(transactionProvider.notifier).getTransactionSummary();
      }
    });
  }

  int currentPage = 1;
  final int itemsPerPage = 10;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(transactionQueryProvider);
    final stateSum = ref.watch(transactionProvider);
    return Scaffold(
      backgroundColor: AppColor.primarywhite,
      appBar: const HeaderAdminProduct(
        isIcon: false,
        category: false,
        header: 'Table',
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Container(
                      width: 400,
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        color: AppColor.secondarywhite,
                        boxShadow: [
                          BoxShadow(
                            color: AppColor.black10,
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Text(
                              'Sales Summary',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ReportCard(
                                iconBgColor: AppColor.yellow28,
                                iconColor: AppColor.yellow100,
                                icon: Icons.request_quote_outlined,
                                headerText: 'Cash',
                                mainText: stateSum is TransactionLoadedSummery ? formatRupiah(stateSum.summery.cash) : '0',
                                bottomText: stateSum is TransactionLoadedSummery ? stateSum.summery.cashPercent!.toDouble() : 0,
                              ),
                              const SizedBox(width: 6),
                              ReportCard(
                                iconBgColor: AppColor.blue28,
                                iconColor: AppColor.blue100,
                                icon: Icons.trending_up,
                                headerText: 'Sales',
                                mainText: stateSum is TransactionLoadedSummery ? formatRupiah(stateSum.summery.cash + stateSum.summery.nonCash) : '0',
                                bottomText: stateSum is TransactionLoadedSummery ? (stateSum.summery.nonCashPercent!.toDouble() + stateSum.summery.cashPercent!.toDouble()) / 2 : 0,
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ReportCard(
                                iconBgColor: AppColor.yellow28,
                                iconColor: AppColor.yellow100,
                                icon: Icons.request_quote_outlined,
                                headerText: 'Order',
                                mainText: stateSum is TransactionLoadedSummery ? stateSum.summery.totalItem.toString() : '0',
                                bottomText: stateSum is TransactionLoadedSummery ? stateSum.summery.totalItemPercent!.toDouble() : 0,
                              ),
                              const SizedBox(width: 6),
                              ReportCard(
                                iconBgColor: AppColor.blue28,
                                iconColor: AppColor.blue100,
                                icon: Icons.trending_up,
                                headerText: 'E-Money',
                                mainText: stateSum is TransactionLoadedSummery ? formatRupiah(stateSum.summery.nonCash) : '0',
                                bottomText: stateSum is TransactionLoadedSummery ? stateSum.summery.nonCashPercent!.toDouble() : 0,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Table Container
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 1000),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // ===== JUDUL (DI DALAM CONTAINER) =====
                          Container(
                            height: 48,
                            decoration: const BoxDecoration(
                              color: AppColor.primary,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(18),
                                topRight: Radius.circular(18),
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            alignment: Alignment.centerLeft,
                            child: const Text(
                              'Transaction',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          // ===== TABLE HEADER =====
                          Container(
                            height: 32,
                            color: Colors.grey[200],
                            child: Row(
                              children: [
                                _buildHeaderCell('Date Time', flex: 1),
                                _buildHeaderCell('Cashier'),
                                _buildHeaderCell('Total'),
                                _buildHeaderCell('Status'),
                              ],
                            ),
                          ),

                          // ===== TABLE BODY =====
                          Container(
                            constraints: BoxConstraints(
                              minHeight: 50,
                              maxHeight: 330, // 50% dari tinggi layar
                            ),
                            child: state is TransactionQueryLoading
                                ? const Center(child: CircularProgressIndicator())
                                : state is TransactionQueryLoaded
                                    ? _buildTransactionBody(state)
                                    : state is TransactionQueryError
                                        ? Center(child: Text(state.message))
                                        : const SizedBox(),
                          ),

                          // ===== FOOTER =====
                          Container(
                            height: 48,
                            decoration: const BoxDecoration(
                              color: AppColor.primary,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(18),
                                bottomRight: Radius.circular(18),
                              ),
                            ),
                            child: _buildPaginationFooter(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // Spacer untuk memastikan konten terlihat hingga bawah
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTransactionBody(TransactionQueryLoaded state) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: state.transactions.length,
            itemBuilder: (context, index) {
              final transaction = state.transactions[index];
              return Column(
                children: [
                  TableRowWidget(
                    param: {
                      'row1': {
                        'text': DateTimeUtils.formatDate(
                          transaction.createdAt.toString(),
                        ),
                        'type': 'text',
                      },
                      'row2': {
                        'text': transaction.userName,
                        'type': 'text',
                      },
                      'row3': {
                        'text': formatRupiah(
                          transaction.total as num,
                        ),
                        'type': 'text',
                      },
                      'row4': {
                        'text': 'completed',
                        'type': 'status',
                        'format': 'icon',
                      },
                      'flex': {
                        'col1': 1,
                        'col2': 1,
                        'col3': 1,
                        'col4': 1,
                      },
                    },
                  ),
                  if (index != state.transactions.length - 1)
                    const Divider(
                      height: 1,
                      color: Colors.grey,
                    ),
                ],
              );
            },
          ),
        ),
        // Expanded akan memastikan tidak ada space kosong di bawah list
        // jika data kurang dari maksimal tinggi
        if (state.transactions.length < 10)
          Expanded(
            child: Container(),
          ),
      ],
    );
  }

  Widget _buildHeaderCell(String text, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Container(
        width: 400,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            text,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ),
      ),
    );
  }

  Widget _buildPaginationFooter() {
    final state = ref.watch(transactionQueryProvider);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.white),
          onPressed: () {
            if (state is TransactionQueryLoaded && state.currentPage! > 1) {
              ref
                  .read(transactionQueryProvider.notifier)
                  .getTransaction(page: state.currentPage! - 1, limit: 10);
            }
          },
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            state is TransactionQueryLoading
                ? state.currentPage.toString()
                : state is TransactionQueryLoaded
                    ? state.currentPage.toString()
                    : '0',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right, color: Colors.white),
          onPressed: () {
            if (state is TransactionQueryLoaded) {
              if (!state.isLastPage) {
                ref
                    .read(transactionQueryProvider.notifier)
                    .getTransaction(page: state.currentPage! + 1, limit: 10);
              }
            }
          },
        ),
      ],
    );
  }
}