import 'package:flutter/material.dart';

class BookedTicketsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> bookedTickets;

  const BookedTicketsScreen({super.key, required this.bookedTickets});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booked Tickets'),
      ),
      body: ListView.builder(
        itemCount: bookedTickets.length,
        itemBuilder: (context, index) {
          final ticket = bookedTickets[index];
          return Card(
            child: ListTile(
              title: Text(ticket['movieTitle']),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Theater: ${ticket['theaterName']}'),
                  Text('Seats: ${ticket['seats']}'),
                  Text('Total Price: ${ticket['totalSeatPrice']}'),
                  Text('Email: ${ticket['email']}'),
                  Text('Phone: ${ticket['phone']}'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
