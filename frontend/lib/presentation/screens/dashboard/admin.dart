import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/constants/app_color.dart';
import 'package:frontend/core/utils/currency_rupiah.dart';
import 'package:frontend/core/utils/date_time.dart';
import 'package:frontend/presentation/screens/layout/header/header_kasir.dart';
import 'dart:async';
import 'package:frontend/presentation/widgets/common/card_report.dart';
import 'package:frontend/presentation/widgets/dashboard/monthly_chart_card.dart';
import 'package:frontend/presentation/widgets/dashboard/best_seller_card.dart';
import 'package:frontend/state/transaction_provider.dart';
import 'package:frontend/state/auth_provider.dart';

class AdminDashboard extends ConsumerStatefulWidget {
  const AdminDashboard({super.key});

  @override
  ConsumerState<AdminDashboard> createState() => _AdminDashboard();
}

class _AdminDashboard extends ConsumerState<AdminDashboard> {
  late DateTime _now;
  late Timer _timer;
  int? _selectedCashierId;
  String _selectedPeriod = 'today';

  final List<Map<String, String>> _periods = [
    {'value': 'today', 'label': 'Today'},
    {'value': 'this_month', 'label': 'This Month'},
    {'value': 'last_month', 'label': 'Last Month'},
  ];

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
      _fetchData();
      ref.read(userQueryProvider.notifier).getUser();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _fetchData() {
    if (!mounted) return;
    
    // Fetch Summary
    if (_selectedCashierId == null) {
      ref.read(transactionProvider.notifier).getTransactionSummary(period: _selectedPeriod);
    } else {
      ref.read(transactionSummaryByCashierProvider.notifier).getTransactionSummaryByCashier(_selectedCashierId!, period: _selectedPeriod);
    }

    // Fetch Best Seller
    ref.read(bestSellerProductProvider.notifier).getBestSeller(period: _selectedPeriod);
    
    // Monthly Chart is static trend, but we could refresh it if needed
    // ref.refresh(monthlyTransactionProvider);
  }

  void _onCashierChanged(int? id) {
    if (!mounted) return;
    setState(() {
      _selectedCashierId = id;
    });
    _fetchData();
  }

  void _onPeriodChanged(String? period) {
    if (!mounted || period == null) return;
    setState(() {
      _selectedPeriod = period;
    });
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    final summaryState = _selectedCashierId == null
        ? ref.watch(transactionProvider)
        : ref.watch(transactionSummaryByCashierProvider);

    final monthlyData = ref.watch(monthlyTransactionProvider);
    final bestSellerState = ref.watch(bestSellerProductProvider);
    final userData = ref.watch(userQueryProvider);

    final start = DateTime(_now.year, _now.month, 1);
    final end = DateTime(_now.year, _now.month + 1, 0);

    final String comparisonLabel = _selectedPeriod == 'today'
        ? 'from yesterday'
        : (_selectedPeriod == 'this_month' ? 'from last month' : 'from previous month');

    return Scaffold(
      backgroundColor: AppColor.primarywhite,
      appBar: const HeaderKasir(
        isHeaderShow: true,
        header: 'Dashboard',
        name: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 60,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColor.secondarywhite,
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.black10,
                      blurRadius: 10,
                      offset: const Offset(0, 5),
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
                          'Period: ${DateTimeUtils.formatPeriod(start, end)}',
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
                        '${_now.hour.toString().padLeft(2, '0')}:${_now.minute.toString().padLeft(2, '0')}',
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
              
              // Period Filter Global
              Container(
                 width: double.infinity,
                 margin: const EdgeInsets.only(bottom: 20),
                 padding: const EdgeInsets.symmetric(horizontal: 14),
                 decoration: BoxDecoration(
                    color: AppColor.blue100,
                    borderRadius: BorderRadius.circular(12),
                 ),
                 child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      dropdownColor: AppColor.blue100,
                      value: _selectedPeriod,
                      icon: const Icon(Icons.calendar_today, color: Colors.white, size: 18),
                      items: _periods.map((p) => DropdownMenuItem(
                        value: p['value'],
                        child: Text(p['label']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      )).toList(),
                      onChanged: _onPeriodChanged,
                    ),
                 ),
              ),
        
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Sales Summary',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (userData is UserQueryLoaded)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<int?>(
                                hint: const Text('Filter by Cashier', style: TextStyle(fontSize: 12)),
                                value: _selectedCashierId,
                                items: [
                                  const DropdownMenuItem(value: null, child: Text('All Cashiers', style: TextStyle(fontSize: 12))),
                                  ...userData.users.map((u) => DropdownMenuItem(
                                        value: u.id,
                                        child: Text(u.name ?? '', style: const TextStyle(fontSize: 12)),
                                      )),
                                ],
                                onChanged: _onCashierChanged,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: ReportCard(
                            iconBgColor: AppColor.yellow28,
                            iconColor: AppColor.yellow100,
                            icon: Icons.request_quote_outlined,
                            headerText: 'Cash',
                            mainText: summaryState is TransactionLoadedSummery ? formatRupiah(summaryState.summery.cash) : '0',
                            bottomText: summaryState is TransactionLoadedSummery ? (summaryState.summery.cashPercent ?? 0).toDouble() : 0,
                            comparisonLabel: comparisonLabel,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ReportCard(
                            iconBgColor: AppColor.blue28,
                            iconColor: AppColor.blue100,
                            icon: Icons.trending_up,
                            headerText: 'Sales',
                            mainText: summaryState is TransactionLoadedSummery ? formatRupiah(summaryState.summery.cash + summaryState.summery.nonCash) : '0',
                            bottomText: summaryState is TransactionLoadedSummery ? (summaryState.summery.cashPercent ?? 0).toDouble() + (summaryState.summery.nonCashPercent ?? 0).toDouble() : 0,
                            comparisonLabel: comparisonLabel,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: ReportCard(
                            iconBgColor: AppColor.yellow28,
                            iconColor: AppColor.yellow100,
                            icon: Icons.request_quote_outlined,
                            headerText: 'Order',
                            mainText: summaryState is TransactionLoadedSummery ? summaryState.summery.totalItem.toString() : '0',
                            bottomText: summaryState is TransactionLoadedSummery ? (summaryState.summery.totalItemPercent ?? 0).toDouble() : 0,
                            comparisonLabel: comparisonLabel,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ReportCard(
                            iconBgColor: AppColor.blue28,
                            iconColor: AppColor.blue100,
                            icon: Icons.trending_up,
                            headerText: 'E-Money',
                            mainText: summaryState is TransactionLoadedSummery ? formatRupiah(summaryState.summery.nonCash) : '0',
                            bottomText: summaryState is TransactionLoadedSummery ? (summaryState.summery.nonCashPercent ?? 0).toDouble() : 0,
                            comparisonLabel: comparisonLabel,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              monthlyData.when(
                data: (data) => MonthlyTransactionChartCard(data: data),
                loading: () => MonthlyTransactionChartCard(data: []), // Show empty chart while loading
                error: (e, s) => MonthlyTransactionChartCard(data: []),
              ),
              const SizedBox(height: 20),
              _buildBestSellerCard(bestSellerState),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBestSellerCard(BestSellerState state) {
    final label = _periods.firstWhere((p) => p['value'] == _selectedPeriod)['label'] ?? 'Today';
    
    if (state is BestSellerLoaded) {
      return BestSellerProductCard(products: state.products, periodLabel: label);
    }
    return BestSellerProductCard(products: const [], periodLabel: label); // Show empty best seller card while loading
  }
}
