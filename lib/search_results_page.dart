import 'package:flutter/material.dart';
import 'package:ticketmart/bus_operator_details_page.dart';

class SearchResultsPage extends StatelessWidget {
  final String source;
  final String destination;
  final String date;

  const SearchResultsPage({
    super.key,
    required this.source,
    required this.destination,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Results'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(15.0),
        children: [
          const Divider(),
          _buildSearchSummary(),
          const Divider(),
          const SizedBox(height: 20),
          _buildBusList(context),
        ],
      ),
    );
  }

  Widget _buildSearchSummary() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                date,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              Row(
                children: [
                  Text(
                    source,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Icon(
                    Icons.arrow_forward,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    destination,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBusList(BuildContext context) {
  // Sample bus list items with details similar to the image
  final busOptions = [
    {
      'name': 'Rajat Rides Tours and Travels',
      'type': 'A/C Sleeper (2+1)',
      'seatsLeft': '12 seats left',
      'duration': '35h 0m',
      'rating': '2.6',
      'reviews': '12 Ratings',
      'departure': '03:00 PM',
      'arrival': '02:00 AM',
      'price': '₹3,900',
      'features': ['COVID safety'],
    },
    {
      'name': 'Safar travels and cargo',
      'type': 'A/C Sleeper (2+1)',
      'seatsLeft': '14 seats left',
      'duration': '31h 0m',
      'rating': '2.1',
      'reviews': '42 Ratings',
      'departure': '03:45 PM',
      'arrival': '10:45 PM',
      'price': '₹3,000',
      'features': ['COVID safety', 'Live Trackable'],
    },
    {
      'name': 'Raj Travels(EXPRESS)',
      'type': 'A/C Sleeper (2+1)',
      'seatsLeft': '7 seats left',
      'duration': '31h 30m',
      'rating': '1.5',
      'reviews': '20 Ratings',
      'departure': '04:00 PM',
      'arrival': '11:30 PM',
      'price': '₹3,300',
      'features': ['COVID safety', 'Live Trackable'],
    },
    {
      'name': 'Rajat Rides Tours and Travels',
      'type': 'A/C Sleeper (2+1)',
      'seatsLeft': '23 seats left',
      'duration': '36h 0m',
      'rating': '1.8',
      'reviews': '4 Ratings',
      'departure': '04:00 PM',
      'arrival': '04:00 AM',
      'price': '₹4,300',
      'features': ['COVID safety'],
    },
  ];

  return Column(
    children: busOptions.map((bus) {
      final features = bus['features'] as List<String>?;

      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BusOperatorDetailsPage(
                operatorName: bus['name'] as String,
                operatorType: bus['type'] as String,
                operatorTime: bus['departure'] as String,
                operatorRating: bus['rating'] as String,
                operatorReviews: bus['reviews'] as String,
                operatorSeatsLeft: bus['seatsLeft'] as String,
                operatorDuration: bus['duration'] as String,
              ),
            ),
          );
        },
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      bus['name'] as String,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    bus['departure'] as String,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Text(
                bus['type'] as String,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${bus['seatsLeft']} • ${bus['duration']}',
                    style: const TextStyle(fontSize: 14),
                  ),
                  Text(
                    bus['arrival'] as String,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.blue.withOpacity(0.2),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.star, color: Colors.yellow, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          bus['rating'] as String,
                          style: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    bus['reviews'] as String,
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                if (features != null) ...[
                  for (var feature in features)
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Row(
                        children: [
                          Icon(
                            feature == 'COVID safety'
                                ? Icons.shield_outlined
                                : Icons.location_on,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            feature,
                            style: const TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
                ],
              ),
              const SizedBox(height: 10),
              Text(
                bus['price'] as String,
                style: const TextStyle(
                  color: Colors.green,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
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
            Text('Details for $busName',
                style: Theme.of(context).textTheme.titleLarge),
            // Add additional details and booking options here
          ],
        ),
      ),
    );
  }
}
