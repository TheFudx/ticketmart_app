import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your email',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            const SizedBox(height: 8.0),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Enter your email',
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Mobile number',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            const SizedBox(height: 8.0),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                children: [
                  // Country code and flag icon can be added here
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Enter your phone number',
                        border: InputBorder.none,
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                ],
              ),
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
            const SizedBox(height: 16.0),
            const Text(
              '* Terms and conditions',
              style: TextStyle(
                fontSize: 12.0,
                color: Colors.red,
                decoration: TextDecoration.none,
              ),
            ),
            // Add your terms and conditions widget here
          ],
        ),
      ),
    );
  }
}
