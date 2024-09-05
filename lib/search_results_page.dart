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
           actions: [
        IconButton(
          icon: const Icon(Icons.filter_list, color: Colors.black),
          onPressed: () => _openFilterModal(context), // Open the filter modal sheet
        ),
      ],
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

void _openFilterModal(BuildContext context) {
  // Filter state variables
  bool isAcSelected = true;
  bool isNonAcSelected = false;
  bool isSeaterSelected = false;
  bool isSleeperSelected = false;

  // Time filter options
  Map<String, bool> departureTimeOptions = {
    'Before 10 AM': false,
    '10 AM - 5 PM': true,
    '5 PM - 10 PM': false,
    'After 10 PM': false,
  };

  Map<String, bool> arrivalTimeOptions = {
    'Before 10 AM': false,
    '10 AM - 5 PM': false,
    '5 PM - 10 PM': true,
    'After 10 PM': false,
  };

  // Price range state variables
  double minPrice = 100;
  double maxPrice = 5000;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true, // Allow the modal to expand more if needed
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return FractionallySizedBox(
            heightFactor: 0.75, // Adjust the height to include the new section
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom, // Adjust for keyboard
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Filter Options',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Divider(),

                      // Wrap AC, Non-AC, Seater, Sleeper in a more compact layout
                      Wrap(
                        spacing: 10.0, // Spacing between items
                        runSpacing: 10.0, // Spacing between rows
                        children: [
                          FilterChip(
                            label: const Text('AC'),
                            selected: isAcSelected,
                            onSelected: (bool selected) {
                              setState(() {
                                isAcSelected = selected;
                              });
                            },
                          ),
                          FilterChip(
                            label: const Text('Non AC'),
                            selected: isNonAcSelected,
                            onSelected: (bool selected) {
                              setState(() {
                                isNonAcSelected = selected;
                              });
                            },
                          ),
                          FilterChip(
                            label: const Text('Seater'),
                            selected: isSeaterSelected,
                            onSelected: (bool selected) {
                              setState(() {
                                isSeaterSelected = selected;
                              });
                            },
                          ),
                          FilterChip(
                            label: const Text('Sleeper'),
                            selected: isSleeperSelected,
                            onSelected: (bool selected) {
                              setState(() {
                                isSleeperSelected = selected;
                              });
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),
                      const Text(
                        'Departure Time',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Divider(),

                      // Wrap Departure Time options in a more compact layout
                      Wrap(
                        spacing: 10.0, // Spacing between items
                        runSpacing: 10.0, // Spacing between rows
                        children: departureTimeOptions.keys.map((String time) {
                          return FilterChip(
                            label: Text(time),
                            selected: departureTimeOptions[time]!,
                            onSelected: (bool selected) {
                              setState(() {
                                departureTimeOptions[time] = selected;
                              });
                            },
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 20),
                      const Text(
                        'Arrival Time',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Divider(),

                      // Wrap Arrival Time options in a more compact layout
                      Wrap(
                        spacing: 10.0, // Spacing between items
                        runSpacing: 10.0, // Spacing between rows
                        children: arrivalTimeOptions.keys.map((String time) {
                          return FilterChip(
                            label: Text(time),
                            selected: arrivalTimeOptions[time]!,
                            onSelected: (bool selected) {
                              setState(() {
                                arrivalTimeOptions[time] = selected;
                              });
                            },
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 20),
                      const Text(
                        'Price Range',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Divider(),

                      // Price Range Slider
                      RangeSlider(
                        values: RangeValues(minPrice, maxPrice),
                        min: 100,
                        max: 5000,
                        divisions: 49, // Number of discrete values between min and max
                        labels: RangeLabels(
                          '\$${minPrice.toStringAsFixed(0)}',
                          '\$${maxPrice.toStringAsFixed(0)}',
                        ),
                        onChanged: (RangeValues values) {
                          setState(() {
                            minPrice = values.start;
                            maxPrice = values.end;
                          });
                        },
                      ),

                      // Display selected price range
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(
                          'Selected range: \$${minPrice.toStringAsFixed(0)} - \$${maxPrice.toStringAsFixed(0)}',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),

                      // Apply Filters button
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context); // Close modal and apply filters
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue, // Fill color (blue)
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0), // Rectangular border radius
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 15.0,
                              horizontal: 50.0,
                            ), // Adjust padding for button size
                          ),
                          child: const Text(
                            'Apply Filters',
                            style: TextStyle(color: Colors.white), // Text color (white)
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    },
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
