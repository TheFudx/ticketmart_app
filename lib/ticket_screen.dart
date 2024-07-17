import 'package:flutter/material.dart';
import 'package:ticketmart/profile_page.dart';

class TicketScreen extends StatelessWidget {
  final String theaterName;
  final String movieTitle;
  final DateTime selectedDate;
  final TimeOfDay selectedTime;
  final List<List<SeatStatus>> seats;

  const TicketScreen({
    super.key,
    required this.theaterName,
    required this.movieTitle,
    required this.selectedDate,
    required this.selectedTime,
    required this.seats,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Ticket'),
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 3,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
              image: const DecorationImage(
                image: AssetImage('assets/ticket_texture.png'), // Add a subtle paper texture image
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.local_movies,
                        size: 48.0,
                        color: Colors.redAccent,
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Movie Ticket',
                        style: TextStyle(
                          fontFamily: 'Courier', // Use a typewriter-like font for vintage feel
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  color: Colors.black,
                  height: 32.0,
                  thickness: 2.0,
                ),
                Text(
                  'Movie: $movieTitle',
                  style: const TextStyle(
                    fontFamily: 'Courier', // Use a typewriter-like font for vintage feel
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Theater: $theaterName',
                  style: const TextStyle(
                    fontFamily: 'Courier', // Use a typewriter-like font for vintage feel
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Date: ${selectedDate.toLocal().toString().split(' ')[0]}',
                  style: const TextStyle(
                    fontFamily: 'Courier', // Use a typewriter-like font for vintage feel
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Time: ${selectedTime.format(context)}',
                  style: const TextStyle(
                    fontFamily: 'Courier', // Use a typewriter-like font for vintage feel
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Seats:',
                  style: TextStyle(
                    fontFamily: 'Courier', // Use a typewriter-like font for vintage feel
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8.0),
                Wrap(
                  children: _getSelectedSeats()
                      .map((seat) => Container(
                            margin: const EdgeInsets.all(4.0),
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: Colors.yellow[200],
                              borderRadius: BorderRadius.circular(4.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  offset: const Offset(0, 1),
                                  blurRadius: 2,
                                ),
                              ],
                            ),
                            child: Text(
                              seat,
                              style: const TextStyle(
                                fontFamily: 'Courier', // Use a typewriter-like font for vintage feel
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 32.0),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfilePage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Text(
                      'Back to Home',
                      style: TextStyle(
                        fontFamily: 'Courier', // Use a typewriter-like font for vintage feel
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<String> _getSelectedSeats() {
    List<String> selectedSeats = [];
    for (int row = 0; row < seats.length; row++) {
      for (int column = 0; column < seats[row].length; column++) {
        if (seats[row][column] == SeatStatus.selected) {
          selectedSeats.add('Row ${row + 1}, Seat ${column + 1}');
        }
      }
    }
    return selectedSeats;
  }
}

enum SeatStatus {
  available,
  selected,
  booked,
}
