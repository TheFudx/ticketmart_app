import 'package:flutter/material.dart';

class ParkPage extends StatelessWidget {
  const ParkPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Park Page'),
      ),
      body: const Center(
        child: Text('Park Page Content'),
      ),
    );
  }
}
