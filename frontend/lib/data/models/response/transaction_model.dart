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
