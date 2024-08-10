import 'package:flutter/material.dart';

class BusPage extends StatelessWidget {
  const BusPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bus Page'),
      ),
      body: const Center(
        child: Text('Bus Page Content'),
      ),
    );
  }
}
