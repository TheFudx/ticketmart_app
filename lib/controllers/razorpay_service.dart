import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorpayService {
  final Razorpay _razorpay = Razorpay();

  Razorpay get razorpay => _razorpay;

  void openCheckout({
    required double amount,
    required String name,
    required String contact,
    required String email,
  }) {
    var options = {
      'key': 'rzp_live_RZc1dScMas4j6x',
      'amount': (amount * 100).toInt(),
      'name': name,
      'prefill': {'contact': contact, 'email': email},
      'theme': {'color': '#E53935'},
    };

    _razorpay.open(options);
  }

  void dispose() {
    _razorpay.clear();
  }
}
