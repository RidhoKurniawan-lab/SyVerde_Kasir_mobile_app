import 'package:flutter/material.dart';
import 'package:frontend/core/utils/date_time.dart';
import 'package:frontend/presentation/screens/report/table.dart';
import 'package:frontend/core/constants/app_color.dart';
import 'package:frontend/presentation/screens/layout/header/header_admin_product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/state/transaction_provider.dart';

class AuditTable extends ConsumerStatefulWidget {
  const AuditTable({super.key});

  @override
  ConsumerState<AuditTable> createState() => _AuditTableState();
}

class _AuditTableState extends ConsumerState<AuditTable> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = ref.read(auditQueryProvider);
      if (state is! AuditQueryLoaded) {
        ref
            .read(auditQueryProvider.notifier)
            .getAudit(page: 1, limit: 10);
      }
    });
  }

  int currentPage = 1;
  final int itemsPerPage = 10;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(auditQueryProvider);
    return Scaffold(
      backgroundColor: AppColor.primarywhite,
      appBar: const HeaderAdminProduct(
        isIcon: false,
        category: false,
        header: 'Report Audit Log',
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
                              'Audit Log',
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
                                _buildHeaderCell('Action'),
                                _buildHeaderCell('Modul'),
                                _buildHeaderCell('Cashier'),
                              ],
                            ),
                          ),

                          // ===== TABLE BODY =====
                          Container(
                            constraints: BoxConstraints(
                              minHeight: 50,
                              maxHeight: 330, // 50% dari tinggi layar
                            ),
                            child: state is AuditQueryLoading
                                ? const Center(child: CircularProgressIndicator())
                                : state is AuditQueryLoaded
                                    ? _buildTransactionBody(state)
                                    : state is AuditQueryError
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

  Widget _buildTransactionBody(AuditQueryLoaded state) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: state.audits.length,
            itemBuilder: (context, index) {
              final audit = state.audits[index];
              final model = audit.entryableType!.split('\\').last;
              final user = audit.username!.split(' ').first;
              return Column(
                children: [
                  TableRowWidget(
                    param: {
                      'row1': {
                        'text': DateTimeUtils.formatDate(
                          audit.createdAt.toString(),
                        ),
                        'type': 'text',
                      },
                      'row2': {
                        'text': audit.action,
                        'type': 'text',
                      },
                      'row3': {
                        'text': model,
                        'type': 'text',
                      },
                      'row4': {
                        'text': user,
                        'type': 'text',
                      },
                      'flex': {
                        'col1': 1,
                        'col2': 1,
                        'col3': 1,
                        'col4': 1,
                      },
                    },
                  ),
                  if (index != state.audits.length - 1)
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
        if (state.audits.length < 10)
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
    final state = ref.watch(auditQueryProvider);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.white),
          onPressed: () {
            if (state is AuditQueryLoaded && state.currentPage! > 1) {
              ref
                  .read(auditQueryProvider.notifier)
                  .getAudit(page: state.currentPage! - 1, limit: 10);
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
            state is AuditQueryLoading
                ? state.currentPage.toString()
                : state is AuditQueryLoaded
                    ? state.currentPage.toString()
                    : '0',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right, color: Colors.white),
          onPressed: () {
            if (state is AuditQueryLoaded) {
              if (!state.isLastPage) {
                ref
                    .read(auditQueryProvider.notifier)
                    .getAudit(page: state.currentPage! + 1, limit: 10);
              }
            }
          },
        ),
      ],
    );
  }
}