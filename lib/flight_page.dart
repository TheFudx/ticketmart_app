import 'package:flutter/material.dart';

class FlightPage extends StatelessWidget {
  const FlightPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flight Page'),
      ),
      body: const Center(
        child: Text('Flight Page Content'),
      ),
    );
  }
}
