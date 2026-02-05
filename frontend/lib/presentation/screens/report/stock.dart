import 'package:flutter/material.dart';
import 'package:frontend/presentation/screens/report/table.dart';
import 'package:frontend/core/constants/app_color.dart';
import 'package:frontend/presentation/screens/layout/header/header_admin_product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/state/transaction_provider.dart';

class StockTable extends ConsumerStatefulWidget {
  const StockTable({super.key});

  @override
  ConsumerState<StockTable> createState() => _StockTableState();
}

class _StockTableState extends ConsumerState<StockTable> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = ref.read(stockQueryProvider);
      if (state is! StockQueryLoaded) {
        ref
            .read(stockQueryProvider.notifier)
            .getStock(page: 1, limit: 20);
      }
    });
  }

  int currentPage = 1;
  final int itemsPerPage = 10;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(stockQueryProvider);
    return Scaffold(
      backgroundColor: AppColor.primarywhite,
      appBar: const HeaderAdminProduct(
        isIcon: false,
        category: false,
        header: 'Report Stock',
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
                              'Stock',
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
                                _buildHeaderCell('Product', flex: 2),
                                _buildHeaderCell('Stock'),
                                _buildHeaderCell('Unit'),
                                _buildHeaderCell('Status'),
                              ],
                            ),
                          ),

                          // ===== TABLE BODY =====
                          Container(
                            constraints: BoxConstraints(
                              minHeight: 50,
                              maxHeight: 660, // 50% dari tinggi layar
                            ),
                            child: state is StockQueryLoading
                                ? const Center(child: CircularProgressIndicator())
                                : state is StockQueryLoaded
                                    ? _buildTransactionBody(state)
                                    : state is StockQueryError
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

  Widget _buildTransactionBody(StockQueryLoaded state) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: state.stocks.length,
            itemBuilder: (context, index) {
              final stock = state.stocks[index];
              var status = 'Normal';
              if(stock.stock <= 30) {
                status = 'Low';
              }else if(stock.stock < 1){
                status = 'Out';
              }
              return Column(
                children: [
                  TableRowWidget(
                    param: {
                      'row1': {
                        'text': stock.name,
                        'type': 'text',
                      },
                      'row2': {
                        'text': stock.stock.toString(),
                        'type': 'text',
                      },
                      'row3': {
                        'text': stock.unitName,
                        'type': 'text',
                      },
                      'row4': {
                        'text': status,
                        'type': 'status',
                        'format': 'text',
                      },
                      'flex': {
                        'col1': 2,
                        'col2': 1,
                        'col3': 1,
                        'col4': 1,
                      },
                    },
                  ),
                  if (index != state.stocks.length - 1)
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
        if (state.stocks.length < 10)
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
    final state = ref.watch(stockQueryProvider);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.white),
          onPressed: () {
            if (state is StockQueryLoaded && state.currentPage! > 1) {
              ref
                  .read(stockQueryProvider.notifier)
                  .getStock(page: state.currentPage! - 1, limit: 10);
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
            state is StockQueryLoading
                ? state.currentPage.toString()
                : state is StockQueryLoaded
                    ? state.currentPage.toString()
                    : '0',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right, color: Colors.white),
          onPressed: () {
            if (state is StockQueryLoaded) {
              if (!state.isLastPage) {
                ref
                    .read(stockQueryProvider.notifier)
                    .getStock(page: state.currentPage! + 1, limit: 10);
              }
            }
          },
        ),
      ],
    );
  }
}