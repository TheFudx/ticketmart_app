import 'package:flutter/material.dart';

class BusOperatorDetailsPage extends StatelessWidget {
  final String operatorName;

  const BusOperatorDetailsPage({super.key, required this.operatorName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(operatorName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Details for $operatorName', style: Theme.of(context).textTheme.titleLarge),
            // Add operator details here
          ],
        ),
      ),
    );
  }
}
