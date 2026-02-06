import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/utils/date_time.dart';
import 'package:frontend/core/constants/app_color.dart';
import 'package:frontend/presentation/screens/layout/header/header_kasir.dart';
import 'package:frontend/presentation/widgets/common/card_transaction.dart';
import 'package:frontend/presentation/widgets/common/custom_search.dart';
import 'package:frontend/state/transaction_provider.dart';

class Transaction extends ConsumerStatefulWidget {
  const Transaction({super.key});
  @override
  ConsumerState<Transaction> createState() => _Transaction();
}

class _Transaction extends ConsumerState<Transaction> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  String _searchQuery = '';

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
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      setState(() {
        _searchQuery = query;
      });
      if (query.isNotEmpty) {
        ref.read(transactionSearchProvider.notifier).getTransaction(query: query);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final queryState = ref.watch(transactionQueryProvider);
    final searchState = ref.watch(transactionSearchProvider);
    
    final state = _searchQuery.isEmpty ? queryState : searchState;
    final provider = _searchQuery.isEmpty ? transactionQueryProvider : transactionSearchProvider;

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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: SearchTextField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                hintText: 'Search by Invoice Number...',
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 10),
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
                                .read(provider.notifier)
                                .getTransaction(
                                  page: state.currentPage! - 1,
                                  query: _searchQuery,
                                );
                          }
                        },
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: AppColor.secondarywhite,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              bottomLeft: Radius.circular(12),
                            ),
                            border: Border.all(
                              color: AppColor.primary,
                              width: 0.5,
                            ),
                          ),
                          child: const Center(
                            child: Padding(
                              padding: EdgeInsets.only(left: 8),
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
                        style: const TextStyle(
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
                                  .read(provider.notifier)
                                  .getTransaction(
                                    page: state.currentPage! + 1,
                                    query: _searchQuery,
                                  );
                            }
                          }
                        },
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: AppColor.secondarywhite,
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                            ),
                            border: Border.all(
                              color: AppColor.primary,
                              width: 0.5,
                            ),
                          ),
                          child: const Center(
                            child: Padding(
                              padding: EdgeInsets.only(right: 8),
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
                      ? state.transactions.isEmpty
                        ? const Center(child: Text('No transactions found'))
                        : ListView.builder(
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
                              status: transaction.status ?? 'Completed',
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
