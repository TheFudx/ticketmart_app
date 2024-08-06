import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart';

class TicketScreen extends StatefulWidget {
  final String theaterName;
  final String movieTitle;
  final List<int> seats;
  final int totalSeatPrice;
  final String email;
  final String phone;

  const TicketScreen({
    super.key,
    required this.theaterName,
    required this.movieTitle,
    required this.seats,
    required this.totalSeatPrice,
    required this.email,
    required this.phone,
  });

  @override
  State<TicketScreen> createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

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
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // _buildSuccessMessage(),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Center(
                child: Image.asset(
                  'assets/images/popcorn.png',
                  height: 200.0,
                ),
                
              ),
              const SizedBox(height: 10.0),
              Center(
                child: Text(
                  widget.movieTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTicketDetailColumn(
                    'Seat',
                    widget.seats
                        .map((seat) =>
                            '${seat ~/ 10 + 1}${String.fromCharCode(65 + seat % 10)}')
                        .join(', '),
                  ),
                  const SizedBox(height: 10.0),
                  _buildTicketDetailColumn('Location', widget.theaterName),
                  const SizedBox(height: 10.0),
                  _buildTicketDetailColumn('Payment', 'Card'),
                  const SizedBox(height: 10.0),
                  _buildTicketDetailColumn('Order #', '34678'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdditionalDetails() {
    return ClipPath(
      clipper: InvertedTicketClipper(),
      child: Container(
        color: Colors.grey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Text(
                'Scan this barcode at the entrance of the Theatre',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14.0,
                ),
              ),
              const SizedBox(height: 10.0),
              BarcodeWidget(
                barcode: Barcode.code128(),
                data: 'Ticket ID: 34678',
                height: 100.0,
                drawText: false,
              ),
            ],
          ),
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
          style: const TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 5.0),
        Text(
          detail,
          style: const TextStyle(color: Colors.white),
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
        backgroundColor: Colors.blueAccent,
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      child: const Text(
        'Download tickets',
        style: TextStyle(
          fontSize: 14.0,
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
    path.lineTo(0, size.height * 0.10);
    path.lineTo(size.width * 0.04, 0);
    path.lineTo(size.width * 0.96, 0);
    path.lineTo(size.width, size.height * 0.10);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
