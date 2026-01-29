import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorpayResp {
  static void handlePaymentSuccess(PaymentSuccessResponse response) async {
    print("SUCCESS: ${response.paymentId}");

    await http.post(
      Uri.parse("https://yourdomain.com/verify_payment.php"),
      body: {
        "payment_id": response.paymentId!,
        "order_id": response.orderId!,
        "signature": response.signature!,
      },
    );
  }

  static void handlePaymentError(PaymentFailureResponse response) {
    print("ERROR: ${response.message}");
  }

  static void handleExternalWallet(ExternalWalletResponse response) {
    print("WALLET: ${response.walletName}");
  }
}
