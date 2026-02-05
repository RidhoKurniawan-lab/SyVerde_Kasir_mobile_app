import 'package:intl/intl.dart';

String formatRupiah(
  num value, {
  bool withSymbol = true,
}) {
  final formatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: withSymbol ? 'Rp.' : '',
    decimalDigits: 2,
  );

  return formatter.format(value);
}

String formatRupiahCompact(int amount) {
  if (amount >= 1000000) {
    double juta = amount / 1000000;
    // langsung pakai toStringAsFixed tanpa rounding tambahan
    String formatted = juta.toStringAsFixed(2);
    return 'Rp. $formatted juta';
  } else if (amount >= 1000) {
    double ribu = amount / 1000;
    String formatted = ribu.toStringAsFixed(2);
    return 'Rp. $formatted ribu';
  } else {
    return 'Rp. $amount';
  }
}
