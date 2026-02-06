import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/constants/app_color.dart';
import 'package:frontend/core/utils/currency_rupiah.dart';
import 'package:frontend/core/utils/date_time.dart';
import 'package:frontend/presentation/screens/layout/header/header_kasir.dart';
import 'dart:async';

import 'package:frontend/presentation/widgets/common/card_dashboard.dart';
import 'package:frontend/state/transaction_provider.dart';
import 'package:frontend/state/auth_provider.dart';

class KasirDashboard extends ConsumerStatefulWidget {
  const KasirDashboard({super.key});

  @override
  ConsumerState<KasirDashboard> createState() => _KasirDashboard();
}

class _KasirDashboard extends ConsumerState<KasirDashboard> {
  late DateTime _now;
  late Timer _timer;
  Timer? _pollingTimer;

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

    _pollingTimer = Timer.periodic(const Duration(seconds: 15), (_) {
      if (!mounted) return;
      final authState = ref.read(authProvider);
      int? userId;
      if (authState is AuthSuccess) {
        userId = authState.user.id;
      }
      ref.read(transactionProvider.notifier).getTransactionSummary(silent: true, userId: userId);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = ref.read(transactionProvider);
      if (state is! TransactionLoadedSummery) {
        final authState = ref.read(authProvider);
        int? userId;
        if (authState is AuthSuccess) {
          userId = authState.user.id;
        }
        ref.read(transactionProvider.notifier).getTransactionSummary(userId: userId);
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pollingTimer?.cancel();
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

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SummaryCard(
                  iconBgColor: AppColor.yellow28,
                  iconColor: AppColor.yellow100,
                  icon: Icons.request_quote_outlined,
                  headerText: 'Cash',
                  mainText: state is TransactionLoadedSummery ? formatRupiah(state.summery.cash): '0',
                  bottomText: 'Current cash available in register',
                ),
                const SizedBox(width: 10),
                SummaryCard(
                  iconBgColor: AppColor.blue28,
                  iconColor: AppColor.blue100,
                  icon: Icons.trending_up,
                  headerText: 'Sales',  
                  mainText: state is TransactionLoadedSummery ? formatRupiah(state.summery.cash + state.summery.nonCash): '0',
                  bottomText: 'Net after refunds & voids',
                ),
              ],
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SummaryCard(
                  iconBgColor: AppColor.red28,
                  iconColor: AppColor.red100,
                  icon: Icons.task_outlined,
                  headerText: 'Order',
                  mainText: state is TransactionLoadedSummery ? state.summery.totalItem.toString(): '0',
                  bottomText: 'Order items per day',
                ),
                const SizedBox(width: 10),
                SummaryCard(
                  iconBgColor: AppColor.purple28,
                  iconColor: AppColor.purple100,
                  icon: Icons.account_balance_wallet_outlined,
                  headerText: 'E-Money',
                  mainText: state is TransactionLoadedSummery ? formatRupiah(state.summery.nonCash): '0',
                  bottomText: 'Non-cash payments',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
