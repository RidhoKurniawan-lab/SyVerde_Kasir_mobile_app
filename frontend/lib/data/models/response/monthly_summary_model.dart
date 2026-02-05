class MonthlySummary {
  final String month;
  final double cash;
  final double nonCash;
  final double totalTransaction;

  MonthlySummary({
    required this.month,
    required this.cash,
    required this.nonCash,
    required this.totalTransaction,
  });

  factory MonthlySummary.fromJson(Map<String, dynamic> json) {
    return MonthlySummary(
      month: json['month'],
      cash: double.tryParse(json['cash'].toString()) ?? 0.0,
      nonCash: double.tryParse(json['non_cash'].toString()) ?? 0.0,
      totalTransaction: double.tryParse(json['total_transaction'].toString()) ?? 0.0,
    );
  }
}
