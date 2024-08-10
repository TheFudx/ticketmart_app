import 'package:flutter/material.dart';

class TrainPage extends StatelessWidget {
  const TrainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Train Page'),
      ),
      body: const Center(
        child: Text('Train Page Content'),
      ),
    );
  }
}
