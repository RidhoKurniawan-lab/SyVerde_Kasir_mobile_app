import 'dart:math';
import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_color.dart';
import 'package:frontend/core/utils/currency_rupiah.dart';
import 'package:frontend/data/models/response/monthly_summary_model.dart';

class MonthlyTransactionChartCard extends StatelessWidget {
  final List<MonthlySummary> data;

  const MonthlyTransactionChartCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return _buildContainer(
        child: const Center(child: Text('No data available')),
      );
    }

    final maxVal = data.map((e) => e.totalTransaction).reduce(max);
    final displayMax = maxVal == 0 ? 1.0 : maxVal * 1.2;

    return _buildContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Monthly Sales Trend',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: data.take(6).map((e) { // Show last 6 months for better visibility in mobile
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          _buildBar(e.totalTransaction, displayMax, AppColor.blue100.withOpacity(0.3)),
                          _buildBar(e.nonCash, displayMax, AppColor.blue100),
                          _buildBar(e.cash, displayMax, AppColor.yellow100),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _formatMonth(e.month),
                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegend(AppColor.yellow100, 'Cash'),
              const SizedBox(width: 16),
              _buildLegend(AppColor.blue100, 'QRIS'),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildBar(double value, double max, Color color) {
    return Container(
      width: 20,
      height: (value / max) * 150, // dynamic height
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildLegend(Color color, String label) {
    return Row(
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 10)),
      ],
    );
  }

  Widget _buildContainer({required Widget child}) {
    return Container(
      width: double.infinity,
      height: 250,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.secondarywhite,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: AppColor.black10, blurRadius: 10, offset: const Offset(0, 5)),
        ],
      ),
      child: child,
    );
  }

  String _formatMonth(String month) {
    // month is "YYYY-MM"
    final parts = month.split('-');
    if (parts.length < 2) return month;
    final m = int.parse(parts[1]);
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[m - 1];
  }
}
