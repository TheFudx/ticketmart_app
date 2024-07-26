import 'package:flutter/material.dart';

class StreamPage extends StatelessWidget {
  const StreamPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stream')),
      body: const Center(child: Text('This is the Stream Page')),
    );
  }
}
