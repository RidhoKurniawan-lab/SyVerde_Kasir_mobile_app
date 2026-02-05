class TransactionSummary {
  final int cash;
  final int nonCash;
  final int totalItem;
  final double? cashPercent;
  final double? nonCashPercent;
  final double? totalItemPercent;

  TransactionSummary({
    required this.cash,
    required this.nonCash,
    required this.totalItem,
    this.cashPercent,
    this.nonCashPercent,
    this.totalItemPercent
  });

  factory TransactionSummary.fromJson(Map<String, dynamic> json) {
    return TransactionSummary(
      cash: int.parse(json['cash'].toString()),
      nonCash: int.parse(json['non_cash'].toString()),
      totalItem: int.parse(json['total_item'].toString()),
      cashPercent: (json['cash_change_percent'] as num).toDouble(),
      nonCashPercent: (json['non_cash_change_percent'] as num).toDouble(),
      totalItemPercent: (json['total_item_change_percent'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
  return {
    'cash': cash,
    'cash_change_percent': cashPercent,
    'non_cash': nonCash,
    'non_cash_change_percent': nonCashPercent,
    'total_item': totalItem,
    'total_item_change_percent': totalItemPercent,
  };
}
}
