import 'package:flutter/material.dart';
import 'package:frontend/core/utils/currency_rupiah.dart';
import 'package:frontend/core/utils/date_time.dart';
import 'package:frontend/presentation/screens/report/table.dart';
import 'package:frontend/core/constants/app_color.dart';
import 'package:frontend/presentation/screens/layout/header/header_admin_product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/presentation/widgets/common/card_filter.dart';
import 'package:frontend/presentation/widgets/common/card_report.dart';
import 'package:frontend/state/auth_provider.dart';
import 'package:frontend/state/category_provider.dart';
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

      final stateUser = ref.read(userQueryProvider);
      if (stateUser is! UserQueryLoaded) {
        ref.read(userQueryProvider.notifier).getUser();
      }
    });
  }

  int currentPage = 1;
  final int itemsPerPage = 10;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(transactionQueryProvider);
    final stateSum = ref.watch(transactionProvider);
    final stateUser = ref.watch(userQueryProvider);
    return Scaffold(
      backgroundColor: AppColor.primarywhite,
      appBar: const HeaderAdminProduct(
        isIcon: false,
        category: false,
        header: 'Report Seles',
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: FilterCard(
                        cashiers: stateUser is UserQueryLoaded
                            ? stateUser.users
                            : [],
                        onApplyFilter: (startDate, endDate, cashierName) {
                          ref.read(transactionQueryProvider.notifier).getTransaction(
                            startDate: startDate,
                            endDate: endDate,
                            userId: cashierName
                          );
                        },
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
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
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
                                  ? const Center(
                                      child: CircularProgressIndicator(),
                                    )
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
                      'row2': {'text': transaction.userName, 'type': 'text'},
                      'row3': {
                        'text': formatRupiah(transaction.total as num),
                        'type': 'text',
                      },
                      'row4': {
                        'text': transaction.status,
                        'type': 'status',
                        'format': 'icon',
                      },
                      'flex': {'col1': 1, 'col2': 1, 'col3': 1, 'col4': 1},
                    },
                  ),
                  if (index != state.transactions.length - 1)
                    const Divider(height: 1, color: Colors.grey),
                ],
              );
            },
          ),
        ),
        // Expanded akan memastikan tidak ada space kosong di bawah list
        // jika data kurang dari maksimal tinggi
        if (state.transactions.length < 10) Expanded(child: Container()),
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
