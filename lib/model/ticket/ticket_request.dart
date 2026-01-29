class TicketRequest {
  final String email;
  final String mobile;
  final int showtimeId;
  final String seats;
  final double amount;
  final String? razorpayPaymentId;
  final String? razorpayOrderId;
  final String? razorpaySignature;

  TicketRequest({
    required this.email,
    required this.mobile,
    required this.showtimeId,
    required this.seats,
    required this.amount,
    required this.razorpayPaymentId,
    required this.razorpayOrderId,
    required this.razorpaySignature,
  });

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "mobile": mobile,
      "showtime_id": showtimeId,
      "seats": seats,
      "amount": amount,
      "razorpay_payment_id": razorpayPaymentId ?? "test",
      "razorpay_order_id": razorpayOrderId ?? "test",
      "razorpay_signature": razorpaySignature ?? "test",
    };
  }
}
