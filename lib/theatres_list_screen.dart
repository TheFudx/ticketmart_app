import 'package:flutter/material.dart';
import 'package:ticketmart/theatre_booking_screen.dart';

class TheatersListScreen extends StatefulWidget {
  final String movieTitle;
  final String imageUrl;

  const TheatersListScreen({
    super.key,
    required this.movieTitle,
    required this.imageUrl,
  });

  @override
  State<TheatersListScreen> createState() => _TheatersListScreenState();
}

class _TheatersListScreenState extends State<TheatersListScreen> {
  int _ticketCount = 1; // Initial ticket count

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Theater'),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildMovieImage(),
            const SizedBox(height: 20.0),
            _buildTheaterCard('ABC Cinema Hall', 'Mumbai'),
            const SizedBox(height: 10.0),
            _buildTheaterCard('XYZ Multiplex', 'Delhi - NCR'),
            const SizedBox(height: 10.0),
            _buildTheaterCard('PQR Theatres', 'Bengaluru'),
            const SizedBox(height: 10.0),
            _buildTheaterCard('LMN Cineplex', 'Hyderabad'),
          ],
        ),
      ),
    );
  }

  Widget _buildMovieImage() {
    return Stack(
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
          padding:
              const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
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
    );
  }

  Widget _buildTheaterCard(String theaterName, String city) {
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  theaterName,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _showTicketSelectionModal(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30.0, vertical: 15.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text(
                    'Book Tickets',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            Text(
              city,
              style: const TextStyle(
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTicketSelectionModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Container(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Select Number of Tickets',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20.0),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 10.0,
                  children: List.generate(
                    9,
                    (index) => GestureDetector(
                      onTap: () {
                        setState(() {
                          _ticketCount = index + 1;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25.0),
                          color: _ticketCount == index + 1
                              ? Colors.redAccent
                              : Colors.grey.withOpacity(0.3),
                        ),
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: _ticketCount == index + 1
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the modal sheet
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TheaterBookingScreen(
                          theaterName: 'Selected Theater', // Replace with actual theater name
                          movieTitle: widget.movieTitle,
                          ticketCount: _ticketCount,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent, // Red background color
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30.0,
                      vertical: 15.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text(
                    'Confirm',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}



}
