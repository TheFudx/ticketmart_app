import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ticketmart/api_connection.dart'; // Import the API connection file
import 'package:intl/intl.dart';
import 'package:ticketmart/theatre_booking_screen.dart'; // For date formatting

class TheatersListScreen extends StatefulWidget {
  final String movieId;
  final String movieTitle;

  const TheatersListScreen({
    super.key,
    required this.movieId,
    required this.movieTitle,
  });

  @override
  State<TheatersListScreen> createState() => _TheatersListScreenState();
}

class _TheatersListScreenState extends State<TheatersListScreen> {
  late Future<List<Map<String, dynamic>>> _theatresFuture;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _theatresFuture =
        ApiConnection.fetchScreens(widget.movieId); // Fetch list of theatres
  }

  List<Map<String, String>> _getDatesForWeek() {
    final today = DateTime.now();
    return List.generate(7, (index) {
      final date = today.add(Duration(days: index));
      return {
        'day': DateFormat('EEE').format(date),
        'date': DateFormat('dd').format(date),
        'month': DateFormat('MMM').format(date),
        'fullDate': DateFormat('yyyy-MM-dd').format(date),
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.movieTitle,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Text(
              widget.movieId,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            
            height: 80.0,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: _getDatesForWeek().map((dateInfo) {
                final isSelected = dateInfo['fullDate'] ==
                    DateFormat('yyyy-MM-dd').format(_selectedDate);
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDate = DateTime.parse(dateInfo['fullDate']!);
                    });
                  },
                  
                  child: Container(
                    
                    width: 51.0,
                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
                    padding: const EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue : Colors.grey[200],
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color: isSelected ? Colors.blue : Colors.grey[200]!,
                        width: 1.0,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          dateInfo['day']!,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.blue, fontSize: 12
                          ),
                        ),
                        Text(
                          dateInfo['date']!,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.blue,  fontSize: 12
                          ),
                        ),
                        Text(
                          dateInfo['month']!,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.blue, fontSize: 12
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _theatresFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No theatres available'));
                } else {
                  final theatres = snapshot.data!;

                  if (kDebugMode) {
                    print('Fetched theatres: $theatres');
                  }

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        const SizedBox(height: 20.0),
                        ...theatres.map<Widget>((theatre) => _buildTheaterCard(
                              theatre['cinema_name'] ?? '',
                              theatre['cinema_location'] ?? '',
                              theatre['cinema_id'] ?? '',
                              theatre['screen_id'] ?? '',
                              theatre['showtimes'] ?? [],
                            )),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

 Widget _buildTheaterCard(String theaterName, String city, String cinemaId,
    String screenId, List<dynamic> showtimes) {
  // Extract the first show's date for display purposes
  String showtimeDate = '';
  if (showtimes.isNotEmpty) {
    final firstShowtime = showtimes.first;
    showtimeDate = DateFormat('yyyy-MM-dd').format(DateTime.parse(firstShowtime['showtime_date']));
  }

  return Card(
    elevation: 5.0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    color: Colors.grey.shade100,
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    theaterName,
                    style: const TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Text(
                    city,
                    style: const TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
              // Add the showtime date to the row
              Row(
                children: [
                  Text(
                    showtimeDate,
                    style: const TextStyle(
                      fontSize: 12.0,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Row(
            children: [
              const SizedBox(width: 10),
              Expanded(
                child: Wrap(
                  spacing: 8.0, // Horizontal spacing between items
                  runSpacing: 4.0, // Vertical spacing between lines
                  children: showtimes.map<Widget>((showtime) {
                    return GestureDetector(
                      onTap: () {
                        // Navigate to the next screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TheaterBookingScreen(
                              showtime: showtime,
                              theatreId: cinemaId,
                              theaterName: theaterName,
                              movieId: widget.movieId, // Pass movie ID
                              movieTitle: widget.movieTitle, // Pass movie title
                              ticketCount: 1,  // Pass default ticket count
                            ),
                          ),
                        );
                      },
                      child: Container(
                        width: 65,
                        margin: const EdgeInsets.only(bottom: 2.0),
                        padding: const EdgeInsets.all(3.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey.shade400,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(2.0),
                        ),
                        child: Center(
                          child: Text(
                            '${showtime['showtime_start_time']}',
                            style: const TextStyle(
                              fontSize: 12.0,
                              color: Colors.green,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
        ],
      ),
    ),
  );
}

  // ignore: unused_element
  void _showTicketSelectionModal(BuildContext context, String theaterName,
      String cinemaId, String screenId, List<dynamic> showtimes) async {
    try {
      // Fetch seat counts assuming it's a List<Map<String, dynamic>>
      final seatCounts = await ApiConnection.fetchSeatCount(cinemaId);

      showModalBottomSheet(
        // ignore: use_build_context_synchronously
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  theaterName,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10.0),
                Text(
                  'Cinema ID: $cinemaId',
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 10.0),
                Text(
                  'Screen ID: $screenId',
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 20.0),
                const Text(
                  'Available Seats:',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10.0),
                // Handle seatCounts as a list of maps, and check for null
                if (seatCounts.isNotEmpty)
                  ...seatCounts.map<Widget>((seatCount) {
                    final seatType = seatCount['seat_type'] ?? 'Unknown';
                    final seatCountValue = seatCount['seat_count'] ?? '0';
                    return ListTile(
                      title: Text('$seatType: $seatCountValue seats'),
                    );
                  })
                else
                  const Text('No seat counts available.'),
                const SizedBox(height: 20.0),
                const Text(
                  'Showtimes:',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10.0),
                ...showtimes.map<Widget>((showtime) => ListTile(
                      title: Text(
                        '${showtime['showtime_start_time']} on ${showtime['showtime_date']}',
                      ),
                    )),
              ],
            ),
          );
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching seat count: $e');
      }
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error fetching seat count')),
      );
    }
  }
}
