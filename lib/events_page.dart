import 'package:flutter/material.dart';

class EventsPage extends StatelessWidget {
  const EventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Events Page'),
      ),
      body: const Center(
        child: Text('Events Page Content'),
      ),
    );
  }
}
