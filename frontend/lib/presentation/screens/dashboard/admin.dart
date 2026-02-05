import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/constants/app_color.dart';
import 'package:frontend/core/utils/currency_rupiah.dart';
import 'package:frontend/core/utils/date_time.dart';
import 'package:frontend/presentation/screens/layout/header/header_kasir.dart';
import 'dart:async';
import 'package:frontend/presentation/widgets/common/card_report.dart';
import 'package:frontend/state/transaction_provider.dart';

class AdminDashboard extends ConsumerStatefulWidget {
  const AdminDashboard({super.key});

  @override
  ConsumerState<AdminDashboard> createState() => _AdminDashboard();
}

class _AdminDashboard extends ConsumerState<AdminDashboard> {
  late DateTime _now;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        _now = DateTime.now();
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = ref.read(transactionProvider);
      if (state is! TransactionLoadedSummery) {
        ref.read(transactionProvider.notifier).getTransactionSummary();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(transactionProvider);
    final start = DateTime(_now.year, _now.month, 1);
    final end = DateTime(_now.year, _now.month + 1, 0);
    return Scaffold(
      backgroundColor: AppColor.primarywhite,
      appBar: const HeaderKasir(
        isHeaderShow: true,
        header: 'Dashboard',
        name: true,
      ),
      body: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 14, vertical: 20),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 60,
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppColor.secondarywhite,
                boxShadow: [
                  BoxShadow(
                    color: AppColor.black10,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${DateTimeUtils.formatDay(_now)}, ${_now.day} ${DateTimeUtils.formatMonth(_now)} ${_now.year}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColor.primary,
                        ),
                      ),

                      Text(
                        'Periode: ${DateTimeUtils.formatPeriod(start, end)}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: AppColor.primary,
                        ),
                      ),
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: Text(
                      '${_now.hour}:${_now.minute}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppColor.blue100,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Container(
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
                        mainText: state is TransactionLoadedSummery
                            ? formatRupiah(state.summery.cash)
                            : '0',
                        bottomText: state is TransactionLoadedSummery
                            ? state.summery.cashPercent!.toDouble()
                            : 0,
                      ),
                      const SizedBox(width: 6),
                      ReportCard(
                        iconBgColor: AppColor.blue28,
                        iconColor: AppColor.blue100,
                        icon: Icons.trending_up,
                        headerText: 'Sales',
                        mainText: state is TransactionLoadedSummery
                            ? formatRupiah(
                                state.summery.cash + state.summery.nonCash,
                              )
                            : '0',
                        bottomText: state is TransactionLoadedSummery
                            ? (state.summery.nonCashPercent!.toDouble() +
                                      state.summery.cashPercent!.toDouble()) /
                                  2
                            : 0,
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
                        mainText: state is TransactionLoadedSummery
                            ? state.summery.totalItem.toString()
                            : '0',
                        bottomText: state is TransactionLoadedSummery
                            ? state.summery.totalItemPercent!.toDouble()
                            : 0,
                      ),
                      const SizedBox(width: 6),
                      ReportCard(
                        iconBgColor: AppColor.blue28,
                        iconColor: AppColor.blue100,
                        icon: Icons.trending_up,
                        headerText: 'E-Money',
                        mainText: state is TransactionLoadedSummery
                            ? formatRupiah(state.summery.nonCash)
                            : '0',
                        bottomText: state is TransactionLoadedSummery
                            ? state.summery.nonCashPercent!.toDouble()
                            : 0,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
