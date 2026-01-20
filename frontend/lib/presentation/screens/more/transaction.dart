import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/utils/date_time.dart';
import 'package:frontend/presentation/screens/layout/header/header_admin_product.dart';
import 'package:frontend/core/constants/app_color.dart';
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
        title: const HeaderAdminProduct(
          isIcon: false,
          category: false,
          header: 'More Menu',
        ),
      ),
      body: state is TransactionQueryLoading
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
    );
  }
}
