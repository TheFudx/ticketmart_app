import 'package:flutter/material.dart';
import 'package:ticketmart/ticket_screen.dart';
import 'package:ticketmart/terms_conditions_modal.dart'; // Import the new file
import 'package:ticketmart/api_connection.dart'; // Import your ApiConnection class
import 'package:razorpay_flutter/razorpay_flutter.dart';

class ProfilePage extends StatefulWidget {
  final String theatreId;
  final String theaterName;
  final String movieId;
  final String movieTitle;
  final List<String> seats; // Change to List<String>
  final int totalSeatPrice;
  final String seatType;
  final Map<String, dynamic> showTime;
  final String email;
  final String phone;
  final int totalPrice;

  const ProfilePage({
    super.key,
    required this.theaterName,
    required this.movieTitle,
    required this.seats,
    required this.showTime,
    required this.seatType,
    required this.totalSeatPrice,
    required this.email,
    required this.phone,
    required this.theatreId,
    required this.movieId,
    required this.totalPrice,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isLoading = false;
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.email;
    _phoneController.text = widget.phone;

    // Initialize Razorpay
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    // Clean up Razorpay instance
    _razorpay.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField(
              'Your email',
              'Enter your email',
              TextInputType.emailAddress,
              _emailController,
            ),
            const SizedBox(height: 14.0),
            _buildTextField(
              'Mobile number',
              'Enter your phone number',
              TextInputType.phone,
              _phoneController,
            ),
            const SizedBox(height: 2.0),
            Text(
              'Your number will be used for sending tickets',
              style: TextStyle(
                fontSize: 12.0,
                fontStyle: FontStyle.italic,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 10.0),
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => const TermsConditionsModal(),
                );
              },
              child: const Text(
                '* Terms and conditions',
                style: TextStyle(
                  fontSize: 12.0,
                  color: Colors.red,
                ),
              ),
            ),
            const SizedBox(height: 24.0),
            Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton(
                onPressed: _isLoading ? null : () => _initiatePayment(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade900,
                  padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Submit', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String hint, TextInputType keyboardType, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14.0,
          ),
        ),
        const SizedBox(height: 8.0),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(2.0),
          ),
          child: TextFormField(
            keyboardType: keyboardType,
            controller: controller,
            decoration: InputDecoration(
              hintText: hint,
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  void _initiatePayment() async {
    final email = _emailController.text;
    final phone = _phoneController.text;

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await ApiConnection.loginOrRegisterUser(email, phone);

      if (result['status'] == 'success') {
        _openRazorpayCheckout();
      } else {
        _showErrorDialog(result['message']);
      }
    } catch (e) {
      _showErrorDialog('Failed to connect to the server');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _openRazorpayCheckout() {
    var options = {
      'key': 'rzp_test_FZs1ciE3h1febU', // Replace with your Razorpay key
      'amount': widget.totalPrice * 100, // Amount in paise
      'name': widget.movieTitle,
      'description': 'Ticket Purchase',
      'prefill': {
        'contact': _phoneController.text,
        'email': _emailController.text,
      },
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      _showErrorDialog('Failed to open Razorpay checkout');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => TicketScreen(
          showTime: widget.showTime,
          theaterName: widget.theaterName,
          movieTitle: widget.movieTitle,
          seats: widget.seats,
          totalSeatPrice: widget.totalSeatPrice,
          seatType: widget.seatType,
          selectedSeats: widget.seats,
          ticketCount: widget.totalSeatPrice,
          email: _emailController.text,
          phone: _phoneController.text,
          theatreId: widget.theatreId,
          movieId: widget.movieId,
          totalPrice: widget.totalPrice,
        ),
      ),
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    _showErrorDialog('Payment failed: ${response.message}');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    _showErrorDialog('Payment failed: ${response.walletName}');
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
