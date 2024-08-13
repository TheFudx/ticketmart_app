import 'package:flutter/material.dart';

class BookingHistoryPage extends StatelessWidget {
  const BookingHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking History'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          // Add history items here
          ListTile(
            title: Text('Booking 1'),
            subtitle: Text('Details about Booking 1'),
          ),
          ListTile(
            title: Text('Booking 2'),
            subtitle: Text('Details about Booking 2'),
          ),
        ],
      ),
    );
  }
}
