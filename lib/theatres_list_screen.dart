import 'package:flutter/material.dart';
import 'package:ticketmart/theatre_booking_screen.dart';

class TheatersListScreen extends StatefulWidget {
  final String movieTitle;
  final String imageUrl; // Assuming you pass the image URL for the movie

  const TheatersListScreen({super.key, required this.movieTitle, required this.imageUrl});

  @override
  State<TheatersListScreen> createState() => _TheatersListScreenState();
}

class _TheatersListScreenState extends State<TheatersListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Theater'),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 3,
                          blurRadius: 7,
                          offset: const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.network(
                        widget.imageUrl,
                        height: 300.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black87],
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10.0),
                        bottomRight: Radius.circular(10.0),
                      ),
                    ),
                    child: Text(
                      widget.movieTitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              _buildTheaterCard('ABC Cinema Hall', 'Mumbai', '9:30 AM', '12:30 PM'),
              const SizedBox(height: 10.0),
              _buildTheaterCard('XYZ Multiplex', 'Delhi - NCR', '11:00 AM', '2:00 PM'),
              const SizedBox(height: 10.0),
              _buildTheaterCard('PQR Theatres', 'Bengaluru', '1:00 PM', '4:00 PM'),
              const SizedBox(height: 10.0),
              _buildTheaterCard('LMN Cineplex', 'Hyderabad', '3:00 PM', '6:00 PM'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTheaterCard(String theaterName, String city, String startTime, String endTime) {
    return Card(
      elevation: 3.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              theaterName,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5.0),
            Text(
              city,
              style: const TextStyle(
                fontSize: 16.0,
              ),
            ),
            const SizedBox(height: 5.0),
            Row(
              children: <Widget>[
                const Icon(Icons.access_time, size: 16.0, color: Colors.grey),
                const SizedBox(width: 5.0),
                Text(
                  '$startTime - $endTime',
                  style: const TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
         ElevatedButton(
  onPressed: () {
    // Navigate to theater booking screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TheaterBookingScreen(
          theaterName: theaterName,
          movieTitle: widget.movieTitle,
          // imageUrl: widget.imageUrl,
        ),
      ),
    );
  },
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.redAccent,
    padding: const EdgeInsets.symmetric(vertical: 15.0),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
  ),
  child: const Text(
    'Book Tickets',
    style: TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.bold,
    ),
  ),
),

          ],
        ),
      ),
    );
  }
}
