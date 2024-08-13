import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart';

class TicketScreen extends StatefulWidget {
  final String theatreId;
  final String theaterName;
  final String movieId;
  final String movieTitle;
  final List<String> seats;
  final int totalSeatPrice;
  final Map<String, dynamic> showTime;
  final String seatType;
  final int ticketCount;
  final String email;
  final String phone;
  final List<String> selectedSeats; 
  final int totalPrice;

  const TicketScreen({
    super.key,
    required this.theatreId,
    required this.theaterName,
    required this.movieId,
    required this.movieTitle,
    required this.seats,
    required this.totalSeatPrice,
    required this.showTime,
    required this.seatType,
    required this.ticketCount,
    required this.email,
    required this.phone, 
    required this.selectedSeats, 
    required this.totalPrice,
  });

  @override
  State<TicketScreen> createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 10.0),
              _buildTicketDetails(),
              _buildAdditionalDetails(),
              const SizedBox(height: 10.0),
              _buildDownloadButton(context),
              _buildBackButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTicketDetails() {
    return ClipPath(
      clipper: TicketClipper(),
      child: Card(
        color: Colors.blue.shade900,
        shape: const RoundedRectangleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: DottedBorder(
            color: Colors.white, // Border color
            strokeWidth: 2.0, // Border width
            dashPattern: const [4, 4], // Pattern for dots and gaps
            borderType: BorderType.RRect, // Rounded rectangle
            radius: const Radius.circular(2.0), // Optional: border radius
            child: Container(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Center(
                    child: Image.asset(
                      'assets/images/popcorn.png',
                      height: 200.0,
                    ),
                  ),
                  Center(
                    child: Text(
                      widget.movieTitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(0.0),
                    ),
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                       _buildTicketDetailRow(
                        'Seat',
                        widget.selectedSeats.join(', '), // Display seat labels directly
                      ),
                      const SizedBox(height: 10.0),
                        _buildTicketDetailRow('Seat Type', widget.seatType),
                        const SizedBox(height: 10.0),
                        _buildTicketDetailRow('Location', widget.theaterName),
                        const SizedBox(height: 10.0),
                        _buildTicketDetailRow('Payment', 'Card'), 
                        const SizedBox(height: 10.0),
                        _buildTicketDetailRow('Total Amount', '${widget.totalPrice}'),
                        const SizedBox(height: 10.0),
                        _buildTicketDetailRow('Email', widget.email),
                        const SizedBox(height: 10.0),
                        _buildTicketDetailRow('Phone', widget.phone),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.green, // Green background color
                      borderRadius: BorderRadius.circular(0.0),
                    ),
                    padding: const EdgeInsets.all(15.0),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Your ticket booked successfully',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                            )),
                        SizedBox(width: 10),
                        Icon(
                          Icons.thumb_up,
                          color: Colors.yellow,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTicketDetailRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12.0,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildAdditionalDetails() {
    return ClipPath(
      clipper: InvertedTicketClipper(),
      child: Container(
        color: Colors.grey.shade300,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: DottedBorder(
            color: Colors.black, // Border color
            strokeWidth: 1.0, // Border width
            dashPattern: const [4, 4], // Pattern for dots and gaps
            borderType: BorderType.RRect, // Rounded rectangle
            radius: const Radius.circular(0.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Scan this barcode at the entrance of the Theatre',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12.0,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  BarcodeWidget(
                    barcode: Barcode.code128(),
                    data: 'Ticket ID: 34678',
                    height: 70.0,
                    drawText: false,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDownloadButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Implement download functionality here
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueAccent,
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      child: const Text(
        'Download tickets',
        style: TextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
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
          color: Colors.black,
          fontSize: 12.0,
        ),
      ),
    );
  }
}

class TicketClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height * 0.95);
    path.lineTo(size.width * 0.05, size.height);
    path.lineTo(size.width * 0.95, size.height);
    path.lineTo(size.width, size.height * 0.95);
    path.lineTo(size.width, 0.10);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class InvertedTicketClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height * 0.05);
    path.lineTo(size.width * 0.05, 0);
    path.lineTo(size.width * 0.95, 0);
    path.lineTo(size.width, size.height * 0.05);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
