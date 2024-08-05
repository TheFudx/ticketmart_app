import 'package:flutter/material.dart';
import 'package:ticketmart/ticket_screen.dart';
import 'package:ticketmart/terms_conditions_modal.dart'; // Import the new file

class ProfilePage extends StatefulWidget {
  final String theaterName;
  final String movieTitle;
  final List<int> seats;
  final int totalSeatPrice;
  final String email;
  final String phone;

  const ProfilePage({super.key, 
    required this.theaterName, 
    required this.movieTitle, 
    required this.seats, 
    required this.totalSeatPrice, 
    required this.email, 
    required this.phone});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
            _buildTextField('Your email', 'Enter your email', TextInputType.emailAddress),
            const SizedBox(height: 14.0),
            _buildTextField('Mobile number', 'Enter your phone number', TextInputType.phone),
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
                onPressed: () => _showOtpDialog(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade900,
                  padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text('Submit', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String hint, TextInputType keyboardType) {
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
            decoration: InputDecoration(
              hintText: hint,
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  void _showOtpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enter OTP'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('A 6-digit OTP has been sent to your mobile number.'),
              SizedBox(height: 12.0),
              OtpInputFields(),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Close the dialog
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Add your OTP submission logic here

                // Close the dialog first
                Navigator.of(context).pop();

                // Navigate to TicketScreen
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TicketScreen(
                      theaterName: widget.theaterName,
                      movieTitle: widget.movieTitle,
                      seats: widget.seats,
                      totalSeatPrice: widget.totalSeatPrice,
                      email: widget.email,
                      phone: widget.phone,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade900),
              child: const Text('Submit', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}

class OtpInputFields extends StatefulWidget {
  const OtpInputFields({super.key});

  @override
  OtpInputFieldsState createState() => OtpInputFieldsState();
}

class OtpInputFieldsState extends State<OtpInputFields> {
  late List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(6, (_) => TextEditingController());
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(6, (index) {
        return SizedBox(
          width: 40.0,
          height: 40.0,
          child: TextField(
            controller: _controllers[index],
            keyboardType: TextInputType.number,
            maxLength: 1,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              counterText: '',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            onChanged: (value) {
              if (value.length == 1 && index != 5) {
                FocusScope.of(context).nextFocus();
              } else if (value.isEmpty && index != 0) {
                FocusScope.of(context).previousFocus();
              }
            },
          ),
        );
      }),
    );
  }
}
