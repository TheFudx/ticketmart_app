// lib/terms_conditions_modal.dart
import 'package:flutter/material.dart';

class TermsConditionsModal extends StatelessWidget {
  const TermsConditionsModal({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Terms & Conditions',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  '1. Introduction\n\n'
                  'Welcome to TicketMart, a platform designed to facilitate the booking of tickets for various movies & events. By using our services, you agree to comply with and be bound by the following terms and conditions. Please read them carefully.\n\n'
                  '2. Acceptance of Terms\n\n'
                  'By accessing and using the TicketMart app, you agree to be bound by these Terms & Conditions, all applicable laws, and regulations. If you do not agree with any part of these terms, you must not use our services.\n\n'
                  '3. Account Registration\n\n'
                  'a. To use certain features of the app, you must register for an account.\n'
                  'b. You are responsible for maintaining the confidentiality of your account information and password.\n'
                  'c. You agree to accept responsibility for all activities that occur under your account.\n\n'
                  '4. Booking and Purchase\n\n'
                  'a. All ticket purchases are subject to availability and acceptance by TicketMart.\n'
                  'b. Prices for tickets are as listed on the app and are subject to change.\n'
                  'c. Payment must be made at the time of booking using the accepted payment methods.\n\n'
                  '5. Cancellation and Refunds\n\n'
                  'a. Cancellation policies vary depending on the event and organizer. Please review the specific event’s cancellation policy before purchasing.\n'
                  'b. Refunds, if applicable, will be processed in accordance with the event organizer’s policy.\n\n'
                  '6. User Conduct\n\n'
                  'a. You agree not to use the app for any unlawful purpose or in any way that might harm, damage, or disparage any other party.\n'
                  'b. You must not misuse our app by knowingly introducing viruses, trojans, worms, or other material that is malicious or technologically harmful.\n\n'
                  '7. Intellectual Property\n\n'
                  'a. All content included on the TicketMart app, such as text, graphics, logos, images, and software, is the property of TicketMart or its content suppliers and protected by applicable intellectual property laws.\n'
                  'b. You may not reproduce, distribute, or create derivative works from any content on the app without our express written consent.',
                  style: TextStyle(fontSize: 14.0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
