import 'package:flutter/material.dart';

class SearchResultsPage extends StatelessWidget {
  final String source;
  final String destination;
  final String date;
  final String time;

  const SearchResultsPage({
    super.key,
    required this.source,
    required this.destination,
    required this.date,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Results'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSearchSummary(),
          const SizedBox(height: 20),
          _buildBusList(context),
        ],
      ),
    );
  }

  Widget _buildSearchSummary() {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: ListTile(
        title: Text('From: $source'),
        subtitle: Text('To: $destination\nDate: $date\nTime: $time'),
      ),
    );
  }

  Widget _buildBusList(BuildContext context) {
    // Sample bus list items
    final busOptions = [
      {'name': 'Bus A', 'details': 'Details about Bus A'},
      {'name': 'Bus B', 'details': 'Details about Bus B'},
      {'name': 'Bus C', 'details': 'Details about Bus C'},
    ];

    return Column(
      children: busOptions.map((bus) {
        return ListTile(
          title: Text(bus['name']!),
          subtitle: Text(bus['details']!),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BusDetailsPage(busName: bus['name']?? ''),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}

class BusDetailsPage extends StatelessWidget {
  final String busName;

  const BusDetailsPage({super.key, required this.busName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(busName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Details for $busName', style: Theme.of(context).textTheme.titleLarge),
            // Add additional details and booking options here
          ],
        ),
      ),
    );
  }
}
