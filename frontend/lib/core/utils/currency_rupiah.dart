import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

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

double parseRupiah(String value) {
  return double.tryParse(value.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
}

class RupiahInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    final double value = parseRupiah(newValue.text);
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: '',
      decimalDigits: 0,
    );

    String newText = formatter.format(value).trim();

    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
