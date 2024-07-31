import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ticketmart/ticket_screen.dart';
import 'package:ticketmart/api_connection.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';


class TheaterBookingScreen extends StatefulWidget {
  final String theatreId;
  final String theaterName;
  final String movieId;
  final String movieTitle;
  final int ticketCount;
  final Map<String, dynamic> showtime;

  const TheaterBookingScreen({
    super.key,
    required this.theatreId,
    required this.theaterName,
    required this.movieId,
    required this.movieTitle,
    required this.ticketCount,
    required this.showtime,
  });

  @override
  TheaterBookingScreenState createState() => TheaterBookingScreenState();
}

class TheaterBookingScreenState extends State<TheaterBookingScreen> {
  List<int> selectedSeats = [];
  int totalSeatPrice = 0;
  Map<int, Map<String, dynamic>> seatData = {};
    late Razorpay _razorpay;

 @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
        _fetchSeatData();

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
  }


 @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TicketScreen(
          theaterName: widget.theaterName,
          movieTitle: widget.movieTitle,
          seats: selectedSeats,
          totalSeatPrice: _calculateTotalSeatPrice(),
        ),
      ),
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Payment failed: ${response.message}')),
    );
  }


  void _proceedToPayment() {
  var options = {
    'key': 'YOUR_RAZORPAY_KEY', // Replace with your Razorpay key
    'amount': totalSeatPrice * 100, // Amount in paise (₹1 = 100 paise)
    'name': 'Theater Booking',
    'description': 'Booking for ${widget.movieTitle}',
    'prefill': {
      'contact': '1234567890',
      'email': 'example@domain.com',
    },
  };

  try {
    _razorpay.open(options);
  } catch (e) {
    if (kDebugMode) {
      print('Error opening Razorpay: $e');
    }
  }
}


  final Map<int, int> rowPrices = {
    0: 230,
    1: 230,
    2: 230,
    3: 250,
    4: 250,
    5: 250,
    6: 250,
    7: 250,
    8: 300,
    9: 300,
  };

  Future<void> _fetchSeatData() async {
    try {
      final screens = await ApiConnection.fetchScreens('');
      setState(() {
        seatData = {
          for (var screen in screens)
            screen['screen_id']: {
              'seat_count': screen['seat_count'],
              'seat_type': _determineSeatType(screen['seat_number'])
            }
        };
      });
    } catch (e) {
      if (kDebugMode) {
        print('Failed to fetch seat data: $e');
      }
    }
  }

  String _determineSeatType(int seatNumber) {
    int rowIndex = seatNumber ~/ 10;
    String seatLabel = String.fromCharCode(65 + rowIndex);

    if (['A', 'B', 'C'].contains(seatLabel)) return 'Normal';
    if (['D', 'E', 'F', 'G'].contains(seatLabel)) return 'Executive';
    return 'Premium';
  }

  int _calculateTotalSeatPrice() {
    return selectedSeats.fold(0, (totalPrice, seat) {
      int row = seat ~/ 10;
      return totalPrice + (rowPrices[row] ?? 0);
    });
  }


  Widget _buildSeatLayout() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          _buildPolygonScreen(),
          _buildSeatGrid(),
        ],
      ),
    );
  }

  Widget _buildPolygonScreen() {
    return Column(
      children: [
        SizedBox(
          height: 50.0,
          width: double.infinity,
          child: CustomPaint(
            size: const Size(double.infinity, 160.0),
            painter: _PolygonPainter(),
          ),
        ),
        const SizedBox(height: 50.0),
      ],
    );
  }

  Widget _buildSeatGrid() {
    return Container(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          children: [
            for (var seatType in ['Normal', 'Executive', 'Premium'])
              _buildSeatSection(seatType),
          ],
        ),
      ),
    );
  }

  Widget _buildSeatSection(String seatType) {
    final seatRanges = _getSeatRanges(seatType);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Text(
            seatType,
            style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Column(
            children: [
              for (var row in seatRanges)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: row.map((seatLabel) {
                    int seatNumber = _seatLabelToNumber(seatLabel);
                    return _buildSeat(seatNumber, seatLabel, seatType);
                  }).toList(),
                ),
            ],
          ),
        ),
      ],
    );
  }

  List<List<String>> _getSeatRanges(String seatType) {
    final seatRanges = {
      'Normal': [
        ...List.generate(10, (index) => 'A${index + 1}'),
        ...List.generate(10, (index) => 'B${index + 1}'),
        ...List.generate(10, (index) => 'C${index + 1}'),
      ],
      'Executive': [
        ...List.generate(10, (index) => 'D${index + 1}'),
        ...List.generate(10, (index) => 'E${index + 1}'),
        ...List.generate(10, (index) => 'F${index + 1}'),
        ...List.generate(10, (index) => 'G${index + 1}'),
        ...List.generate(10, (index) => 'H${index + 1}'),
      ],
      'Premium': [
        ...List.generate(10, (index) => 'I${index + 1}'),
        ...List.generate(10, (index) => 'J${index + 1}'),
      ],
    };

    return seatRanges[seatType]!.fold<List<List<String>>>([], (acc, seat) {
      if (acc.isEmpty || acc.last.length >= 10) acc.add([]);
      acc.last.add(seat);
      return acc;
    });
  }

  int _seatLabelToNumber(String seatLabel) {
    return seatLabel.codeUnitAt(0) - 65 + (int.parse(seatLabel.substring(1)) - 1) * 10;
  }

  Widget _buildSeat(int seatNumber, String seatLabel, String seatType) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (selectedSeats.contains(seatNumber)) {
            selectedSeats.remove(seatNumber);
          } else if (selectedSeats.length < widget.ticketCount) {
            selectedSeats.add(seatNumber);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    'You can select up to ${widget.ticketCount} seats only.'),
              ),
            );
          }
          totalSeatPrice = _calculateTotalSeatPrice();
        });
      },
      child: Container(
        margin: const EdgeInsets.all(4.0),
        padding: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          color: selectedSeats.contains(seatNumber) ? Colors.lightBlue : Colors.white,
          border: Border.all(
            color: selectedSeats.contains(seatNumber) ? Colors.white : Colors.lightBlue,
            width: 0.5,
          ),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Text(
          seatLabel,
          style: TextStyle(
            color: selectedSeats.contains(seatNumber) ? Colors.white : Colors.grey.shade600,
            fontSize: 10.0,
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedSeatsDisplay() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Selected Seats: ${selectedSeats.map((seat) => '${String.fromCharCode(65 + seat ~/ 10)}${seat % 10 + 1}').join(', ')}',
          style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10.0),
        Text(
          'Total Price: ₹$totalSeatPrice',
          style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildSeatStatusIndicator('Available', Colors.transparent, Colors.blue.shade200),
            _buildSeatStatusIndicator('Selected', Colors.lightBlue, Colors.transparent),
            _buildSeatStatusIndicator('Sold', Colors.grey.shade300, Colors.transparent),
          ],
        ),
      ],
    );
  }

  Widget _buildSeatStatusIndicator(String status, Color backgroundColor, Color borderColor) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(color: borderColor, width: 2.0),
            borderRadius: BorderRadius.circular(4.0),
          ),
        ),
        const SizedBox(width: 5),
        Text(status, style: const TextStyle(fontSize: 14.0)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Row(
  children: [
    Text(widget.theatreId),
    const SizedBox(width: 8),
    Expanded(
      child: Text(
        widget.theaterName,
        style: const TextStyle(fontSize: 16),
        overflow: TextOverflow.ellipsis,
      ),
    ),
    const SizedBox(width: 8),
    Text('Seats: ${widget.ticketCount}', style: const TextStyle(fontSize: 16)),
    const SizedBox(width: 8),
    Text(widget.movieTitle, style: const TextStyle(fontSize: 16), overflow: TextOverflow.ellipsis),
    const SizedBox(width: 8),
     Text(
      widget.showtime['time'] ?? 'Showtime',

      style: const TextStyle(fontSize: 16),
      overflow: TextOverflow.ellipsis,
    ),
        const SizedBox(width: 8),
    Text(widget.movieId, style: const TextStyle(fontSize: 16)),

  ],
)

,
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildSeatLayout(),
                    const SizedBox(height: 20.0),
                    _buildSelectedSeatsDisplay(),
                  ],
                ),
              ),
            ),
          ),
          Padding(
  padding: const EdgeInsets.all(50.0),
  child: SizedBox(
    width: screenWidth * 0.9,
    child: ElevatedButton(
      onPressed: _proceedToPayment,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue.shade900,
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
      child: const Text(
        'Proceed to Payment',
        style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    ),
  ),
)

        ],
      ),
    );
  }
}

class _PolygonPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint borderPaint = Paint()
      ..color = Colors.white10
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10.0;

    final Path borderPath = Path()
      ..moveTo(size.width * 0.1, 0)
      ..lineTo(size.width * 0.9, 0)
      ..lineTo(size.width * 0.8, size.height)
      ..lineTo(size.width * 0.2, size.height)
      ..close();

    canvas.drawPath(borderPath, borderPaint);

    final Paint bottomBorderPaint = Paint()
      ..color = Colors.blue.shade400
      ..style = PaintingStyle.stroke
      ..strokeWidth = 40.0
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 100.0);

    final Path bottomBorderPath = Path()
      ..moveTo(size.width * 0.2, size.height)
      ..lineTo(size.width * 0.8, size.height);

    canvas.drawPath(bottomBorderPath, bottomBorderPaint);

    final Paint fillPaint = Paint()
      ..color = Colors.blue.shade400
      ..style = PaintingStyle.fill;

    final Path fillPath = Path()
      ..moveTo(size.width * 0.1, 0)
      ..lineTo(size.width * 0.9, 0)
      ..lineTo(size.width * 0.8, size.height)
      ..lineTo(size.width * 0.2, size.height)
      ..close();

    canvas.drawPath(fillPath, fillPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
