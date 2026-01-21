import 'package:frontend/data/models/response/transaction_item_model.dart';
class CheckoutForm {
  final String paymentMethod;
  final double paidAmount;

  const CheckoutForm({
    this.paymentMethod = '',
    this.paidAmount = 0,
  });

  CheckoutForm copyWith({
    String? paymentMethod,
    double? paidAmount,
  }) {
    return CheckoutForm(
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paidAmount: paidAmount ?? this.paidAmount,
    );
  }
}

class TransactionModel {
  final int? id;
  final String? invoiceNumber;
  final int? userId;

  final double? total;
  final double? discountTotal;
  final double? grandTotal;

  final String? paymentMethod;
  final double? paidAmount;
  final double? changeAmount;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  final List<TransactionItemModel>? items;

  const TransactionModel({
    this.id,
    this.invoiceNumber,
    this.userId,
    this.total,
    this.discountTotal,
    this.grandTotal,
    this.paymentMethod,
    this.paidAmount,
    this.changeAmount,
    this.createdAt,
    this.updatedAt,
    this.items,
  });


  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      invoiceNumber: json['invoice_number'],
      userId: json['user_id'],
      total: (json['total'] as num?)?.toDouble(),
      discountTotal: (json['discount_total'] as num?)?.toDouble(),
      grandTotal: (json['grand_total'] as num?)?.toDouble(),
      paymentMethod: json['payment_method'],
      paidAmount: (json['paid_amount'] as num?)?.toDouble(),
      changeAmount: (json['change_amount'] as num?)?.toDouble(),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      items: (json['items'] as List?)
        ?.where((e) => e != null)
        .map(
          (e) => TransactionItemModel.fromJson(
            e as Map<String, dynamic>,
          ),
        )
        .toList() 
        ?? [],
    );
  }

  /// TO API (REQUEST)
  Map<String, dynamic> toJson() {
    return {
      'payment_method': paymentMethod,
      'paid_amount': paidAmount,
      'total': total,
      'discount_total': discountTotal,
      'grand_total': grandTotal,
      'change_amount': changeAmount,
      if (items != null)
        'items': items!.map((e) => e.toJson()).toList(),
    };
  }
}
