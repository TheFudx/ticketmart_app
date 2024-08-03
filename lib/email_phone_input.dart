import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class EmailPhoneInput extends StatefulWidget {
  final Function(String, String) onSubmit;

  const EmailPhoneInput({super.key, required this.onSubmit});

  @override
  EmailPhoneInputState createState() => EmailPhoneInputState();
}

class EmailPhoneInputState extends State<EmailPhoneInput> {
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Enter Your Details'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Email',
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              labelText: 'Phone',
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final email = _emailController.text.trim();
            final phone = _phoneController.text.trim();
            if (kDebugMode) {
              print('Email: $email, Phone: $phone');
            } // Debugging line
            widget.onSubmit(email, phone);
            Navigator.of(context).pop();
          },
          child: const Text('Submit'),
        ),
      ],
    );
  }
}
