import 'package:flutter/material.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Policy', style: TextStyle(fontWeight: FontWeight.bold),)),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '1. Introduction\n\n',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                  TextSpan(
                    text: 'Welcome to TicketMart. This Privacy Policy explains how we collect, use, disclose, and protect your information when you use our services. By using TicketMart, you agree to the collection and use of information in accordance with this policy.\n\n',
                    style: TextStyle(fontSize: 16),
                  ),
                  TextSpan(
                    text: '2. Information We Collect\n\n',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                  TextSpan(
                    text: 'a. Personal Information: When you register an account or book a ticket, we may collect personal information such as your name, email address, phone number, payment information, and any other details you provide.\n\n'
                        'b. Usage Data: We may collect information about how you access and use the app, including your device’s Internet Protocol (IP) address, browser type, operating system, and other diagnostic data.\n\n'
                        'c. Location Data: We may collect information about your location if you allow it. This data is used to provide location-based services related to the app.\n\n',
                    style: TextStyle(fontSize: 16),
                  ),
                  TextSpan(
                    text: '3. Use of Information\n\n',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                  TextSpan(
                    text: 'We use the collected information for various purposes, including:\n\n'
                        'a. To provide and maintain our services.\n'
                        'b. To process your transactions and manage your bookings.\n'
                        'c. To communicate with you, including sending notifications about your account and bookings.\n'
                        'd. To improve our services and develop new features.\n'
                        'e. To detect, prevent, and address technical issues or fraudulent activity.\n\n',
                    style: TextStyle(fontSize: 16),
                  ),
                  TextSpan(
                    text: '4. Your Rights\n\n',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                  TextSpan(
                    text: 'Depending on your location, you may have certain rights regarding your personal information, including:\n\n'
                        'a. The right to access and receive a copy of the information we hold about you.\n'
                        'b. The right to rectify any inaccurate or incomplete information.\n'
                        'c. The right to request the deletion of your information.\n'
                        'd. The right to object to or restrict the processing of your information.\n'
                        'e. The right to data portability.\n\n',
                    style: TextStyle(fontSize: 16),
                  ),
                  TextSpan(
                    text: '5. Changes to This Privacy Policy\n\n',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                  TextSpan(
                    text: 'We may update our Privacy Policy from time to time. Any changes will be posted on this page, and we will notify you of any significant changes through the app or by email.',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
