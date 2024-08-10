import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ticketmart/profile_page.dart';
import 'package:ticketmart/api_connection.dart';
import 'package:intl/intl.dart';

class TheaterBookingScreenCopy extends StatefulWidget {
  final String theatreId;
  final String theaterName;
  final String movieId;
  final String movieTitle;
  final int ticketCount;
  final Map<String, dynamic> showtime;
  final String seatType;

  const TheaterBookingScreenCopy({
    super.key,
    required this.theatreId,
    required this.theaterName,
    required this.movieId,
    required this.movieTitle,
    required this.ticketCount,
    required this.showtime,
    required this.seatType,
  });

  @override
  TheaterBookingScreenCopyState createState() =>
      TheaterBookingScreenCopyState();
}

// Define a class to represent seat data
class SeatData {
  final String seatType;
  final String section;
  final int price;
  final int commissionPrice;
  final List<int> seatNumbers;

  SeatData({
    required this.seatType,
    required this.section,
    required this.price,
    required this.commissionPrice,
    required this.seatNumbers,
  });

  factory SeatData.fromJson(Map<String, dynamic> json) {
    return SeatData(
      seatType: json['seat_type'],
      section: json['section'],
      price: json['price'],
      commissionPrice: json['commission_price'],
      seatNumbers: List<int>.from(json['seat_numbers']),
    );
  }
}

// Function to process and group seat data
Map<String, List<Map<String, dynamic>>> processSeatData(List<dynamic> data) {
  // Create a map to hold the grouped seat data
  Map<String, List<Map<String, dynamic>>> groupedSeats = {};

  // Iterate over the data and group by seat type
  for (var item in data) {
    SeatData seat = SeatData.fromJson(item);

    if (!groupedSeats.containsKey(seat.seatType)) {
      groupedSeats[seat.seatType] = [];
    }

    groupedSeats[seat.seatType]!.add({
      'section': seat.section,
      'price': seat.price,
      'commission_price': seat.commissionPrice,
      'seat_numbers': seat.seatNumbers,
    });
  }

  return groupedSeats;
}

class TheaterBookingScreenCopyState extends State<TheaterBookingScreenCopy> {
  List<int> selectedSeats = [];
  int totalSeatPrice = 0;
  Map<int, Map<String, dynamic>> seatData = {};

  @override
  void initState() {
    super.initState();
    _fetchSeatData();
  }

  void _fetchSeatData() async {
    try {
      final screens =
          await ApiConnection.fetchSeats(int.parse(widget.theatreId));
      if (kDebugMode) {
        print('Fetched seat data: $screens');
      }

      setState(() {
        seatData = {
          for (var screen in screens)
            (screen['screen_id'] ?? 0): {
              'seat_count': screen['total_seats'] ?? 0,
              'seat_type': screen['seat_type'] ?? 'Unknown',
              'seats': screen['seats'] ?? []
            }
        };
      });
    } catch (e) {
      if (kDebugMode) {
        print('Failed to fetch seat data: $e');
      }
    }
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
            _buildSeatStatusIndicator(
                'Available', Colors.transparent, Colors.blue.shade200),
            _buildSeatStatusIndicator(
                'Selected', Colors.lightBlue, Colors.transparent),
            _buildSeatStatusIndicator(
                'Sold', Colors.grey.shade300, Colors.transparent),
          ],
        ),
      ],
    );
  }

  Widget _buildSeatStatusIndicator(
      String status, Color backgroundColor, Color borderColor) {
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

  String _formatDate(String? date) {
    if (date == null) return 'Date';

    final dateFormat = DateFormat('E, dd MMM');
    final parsedDate = DateTime.parse(date);
    return dateFormat.format(parsedDate);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [                 
                  Text(
                    widget.theaterName,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.movieTitle,
                    style: const TextStyle(fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Spacer(),
            Expanded(
              flex: 1,
              child: Text(
                widget.theatreId,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(
              child: Text(
                widget.movieId,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Spacer(),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 0.5),
                borderRadius: BorderRadius.circular(4.0),
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
              child: Text(
                widget.showtime['showtime_start_time'] ?? 'Start Time',
                style: const TextStyle(fontSize: 11, color: Colors.green),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
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
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context); // Navigate to the previous page
                      },
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _formatDate(widget.showtime['showtime_date']),
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(width: 5.0),
                            const Icon(Icons.edit_outlined,
                                size: 12.0, color: Colors.blue),
                            const SizedBox(width: 5.0),
                            Text(
                              '${widget.ticketCount} Ticket, ${widget.seatType}',
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 10.0),
                    _buildPolygonScreen(), // Ensure this method is actually used
                    const SizedBox(height: 10.0),

                    _buildDynamicSeatsDisplay(),
                    const SizedBox(height: 10.0),

                    _buildSelectedSeatsDisplay(),
                    const SizedBox(height: 20.0),
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
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfilePage(
                              theaterName: 'theatreName',
                              movieTitle: 'movie',
                              seats: [1, 2, 3],
                              totalSeatPrice: 100,
                              email: 'email',
                              phone: 'phone',
                              showTime: {},
                              seatType: '',
                              theatreId: '',
                              movieId: '',
                            )),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade900,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 15.0),
                ),
                child: const Text(
                  'Proceed to Payment',
                  style: TextStyle(fontSize: 16.0, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDynamicSeatsDisplay() {
  if (seatData.isEmpty) {
    return const Center(child: Text('No seats available'));
  }

  if (kDebugMode) {
    print("Seat Data: $seatData");
  }

  // Group seat sections by seat type
  final seatTypes = <String, List<Map<String, dynamic>>>{
    'Normal': [],
    'Executive': [],
    'Premium': [],
  };

  seatData.forEach((screenId, screenData) {
    final seats = screenData['seats'] as List<dynamic>? ?? [];
    final seatType = screenData['seat_type'] ?? 'Unknown';

    if (seatTypes.containsKey(seatType)) {
      seatTypes[seatType]!
          .addAll(seats.map((seat) => seat as Map<String, dynamic>));
    }
  });

  print("Grouped Seat Types: $seatTypes");

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: seatTypes.entries.map((entry) {
      final type = entry.key;
      final seats = entry.value;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            type,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: seats.map((seat) {
              final seatNumber = seat['seat_number'] ?? '';
              final isAvailable = seat['status'] == 'available';
              final isSelected = selectedSeats.contains(
                  int.parse(seatNumber.replaceAll(RegExp(r'^\D+'), '')));

              return GestureDetector(
                onTap: () {
                  if (isAvailable) {
                    setState(() {
                      final seatId = int.parse(
                          seatNumber.replaceAll(RegExp(r'^\D+'), ''));
                      if (selectedSeats.contains(seatId)) {
                        selectedSeats.remove(seatId);
                      } else {
                        if (selectedSeats.length < widget.ticketCount) {
                          selectedSeats.add(seatId);
                        }
                      }

                      totalSeatPrice =
                          selectedSeats.length * (seat['price'] as int);
                    });
                  }
                },
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.lightBlue
                        : (isAvailable
                            ? Colors.transparent
                            : Colors.grey.shade300),
                    border: Border.all(color: Colors.black, width: 1.0),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Center(
                    child: Text(
                      seatNumber,
                      style: TextStyle(
                        color: isAvailable ? Colors.black : Colors.grey,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
        ],
      );
    }).toList(),
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
