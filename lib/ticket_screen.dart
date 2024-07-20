import 'package:flutter/material.dart';

class TicketScreen extends StatefulWidget {
  final String theaterName;
  final String movieTitle;
  final DateTime selectedDate;
  final TimeOfDay selectedTime;
  final List<int> seats;

  const TicketScreen({
    super.key,
    required this.theaterName,
    required this.movieTitle,
    required this.selectedDate,
    required this.selectedTime,
    required this.seats, required int totalSeatPrice,
  });

  @override
  State<TicketScreen> createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Change background color to white
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black), // Change icon color to black
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 20.0),
              _buildSuccessMessage(),
              const SizedBox(height: 20.0),
              _buildTicketDetails(),
              const SizedBox(height: 20.0),
              _buildDownloadButton(context),
              const SizedBox(height: 10.0),
              _buildBackButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessMessage() {
    return const Column(
      children: [
        Icon(Icons.check_circle, color: Colors.green, size: 50.0), // Change icon color to green
        SizedBox(height: 10.0),
        Text(
          'Success!',
          style: TextStyle(
            color: Colors.black, // Change text color to black
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10.0),
        Text(
          'Your payment completed successfully! You can\n download your tickets now',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black, // Change text color to black
            fontSize: 16.0,
          ),
        ),
      ],
    );
  }

  Widget _buildTicketDetails() {
    return Card(
      color: Colors.grey[300], // Change card color to light grey
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: [
                Image.asset(
                  'assets/images/splash_image.png', // Replace with your movie poster asset
                  height: 80.0,
                  width: 100,
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  child: Text(
                    widget.movieTitle,
                    style: const TextStyle(
                      color: Colors.black, // Change text color to black
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTicketDetailColumn('Date', '${widget.selectedDate.day} ${_getMonthName(widget.selectedDate.month)} ${widget.selectedDate.year}'),
                _buildTicketDetailColumn('Time', widget.selectedTime.format(context)),
              ],
            ),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTicketDetailColumn('Seat', widget.seats.map((seat) => '${seat ~/ 10 + 1}${String.fromCharCode(65 + seat % 10)}').join(', ')),
                _buildTicketDetailColumn('Location', widget.theaterName),
              ],
            ),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTicketDetailColumn('Payment', 'Apple Pay'),
                _buildTicketDetailColumn('Order #', '34678'),
              ],
            ),
            const SizedBox(height: 10.0),
            const Divider(color: Colors.grey),
            const SizedBox(height: 10.0),
            Image.asset(
              'assets/images/barcode.png', // Replace with your barcode asset
              height: 200.0,
              width: 300.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTicketDetailColumn(String title, String detail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 5.0),
        Text(
          detail,
          style: const TextStyle(color: Colors.black), // Change text color to black
        ),
      ],
    );
  }

  Widget _buildDownloadButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Implement download functionality here
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green, // Change button color to green
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      child: const Text(
        'Download tickets',
        style: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
          color: Colors.white, // Change text color to white
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.popUntil(context, (route) => route.isFirst);
      },
      child: const Text(
        'Back to home',
        style: TextStyle(
          color: Colors.black, // Change text color to black
          fontSize: 16.0,
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }
}
