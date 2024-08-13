// ignore_for_file: collection_methods_unrelated_type

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ticketmart/profile_page.dart';
import 'package:ticketmart/api_connection.dart';
import 'package:intl/intl.dart';

class TheaterBookingScreen extends StatefulWidget {
  final String theatreId;
  final String theaterName;
  final String movieId;
  final String movieTitle;
  final int ticketCount;
  final Map<String, dynamic> showtime;
  final String seatType;

  const TheaterBookingScreen({
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
  TheaterBookingScreenState createState() => TheaterBookingScreenState();
}

class SeatData {
  final String seatType;
  final String section;
  final int price;
  final int commissionPrice;
  final List<int> seatNumbers; // Changed back to List<int>

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
      seatNumbers: List<int>.from(json['seat_numbers'].map((x) => x)),
    );
  }
}

class TheaterBookingScreenState extends State<TheaterBookingScreen> {
  List<String> selectedSeats =
      []; // Use List<String> to keep track of unique seat identifiers
  int totalSeatPrice = 0;
  int commissionPrice = 0;
  Map<String, List<SeatData>> groupedSeats = {};

  @override
  void initState() {
    super.initState();
    _fetchSeatData();
  }

  void _fetchSeatData() async {
    try {
      final screens =
          await ApiConnection.fetchSeats(int.parse(widget.theatreId));

      setState(() {
        groupedSeats = _groupSeats(screens);
      });
    } catch (e) {
      if (kDebugMode) {
        print('Failed to fetch seat data: $e');
      }
    }
  }

  Map<String, List<SeatData>> _groupSeats(List<dynamic> data) {
    Map<String, List<SeatData>> grouped = {};
    for (var item in data) {
      SeatData seat = SeatData.fromJson(item);
      if (!grouped.containsKey(seat.seatType)) {
        grouped[seat.seatType] = [];
      }
      grouped[seat.seatType]!.add(seat);
    }
    return grouped;
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
    final totalPrice = totalSeatPrice + commissionPrice;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
                    const Divider(),
        Text(
          'Selected Seats: ${selectedSeats.map((seat) {
            // Extract seat section and number
            final seatParts = seat.split('-');
            if (seatParts.length == 2) {
              // Combine section and number without a hyphen
              return '${seatParts[0]}${seatParts[1]}';
            } else {
              return seat;
            }
          }).join(', ')}',
          style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Ticket: ₹$totalSeatPrice',
              style:
                  const TextStyle(fontSize: 14.0, ),
            ),
            const SizedBox(height: 2.0),
            Text(
              'GST: ₹$commissionPrice',
              style:
                  const TextStyle(fontSize: 14.0),
            ),
            const Divider(),
            Text(
              'Total Price: ₹$totalPrice',
              style: const TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.green),
            ),
          ],
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
                'Sold', Colors.grey.shade700, Colors.transparent),
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
        Text(status, style: const TextStyle(fontSize: 10.0)),
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
                          children: [
                            Text(
                              _formatDate(widget.showtime['showtime_date']),
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const Spacer(),
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
                  // Debug print statements
                  if (kDebugMode) {
                    print('Theater Name: ${widget.theaterName}');
                  }
                  if (kDebugMode) {
                    print('Movie Title: ${widget.movieTitle}');
                  }
                  if (kDebugMode) {
                    print('Seats: ${selectedSeats.join(', ')}');
                  }
                  if (kDebugMode) {
                    print('Total Seat Price: ₹$totalSeatPrice');
                  }
                  if (kDebugMode) {
                    print('Email: [Your Email Here]');
                  }
                  if (kDebugMode) {
                    print('Phone: [Your Phone Here]');
                  }
                  if (kDebugMode) {
                    print('Showtime: ${widget.showtime}');
                  }
                  if (kDebugMode) {
                    print('Seat Type: ${widget.seatType}');
                  }
                  if (kDebugMode) {
                    print('Theatre ID: ${widget.theatreId}');
                  }
                  if (kDebugMode) {
                    print('Movie ID: ${widget.movieId}');
                  }
                  if (kDebugMode) {
                    print('Total Price: ₹${totalSeatPrice + commissionPrice}');
                  }

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(
                        theaterName: widget.theaterName,
                        movieTitle: widget.movieTitle,
                        // seats: selectedSeats.map((seat) {
                        //   // Extract seat number from seat identifier
                        //   final seatParts = seat.split('-');
                        //   return int.parse(seatParts[1]); // Assuming the seat number is always an integer
                        // }).toList(),
                        seats: selectedSeats,
                        totalSeatPrice: totalSeatPrice,
                        email: '', // Replace with actual email if available
                        phone:
                            '', // Replace with actual phone number if available
                        showTime: widget.showtime, // Pass the showtime data
                        seatType: widget.seatType,
                        theatreId: widget.theatreId,
                        movieId: widget.movieId,
                        totalPrice: totalSeatPrice + commissionPrice,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  backgroundColor: Colors.blue,
                ),
                child: const Text(
                  'Proceed to Payment',
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDynamicSeatsDisplay() {
    if (groupedSeats.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    List<String> seatTypeOrder = ['Normal', 'Executive', 'Premium'];

    var sortedEntries = groupedSeats.entries.toList()
      ..sort((a, b) {
        int indexA = seatTypeOrder.indexOf(a.key);
        int indexB = seatTypeOrder.indexOf(b.key);
        return indexA.compareTo(indexB);
      });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: sortedEntries.map((entry) {
        String seatType = entry.key;
        List<SeatData> seats = entry.value;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              seatType,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: seats.map((seatData) {
                String section = seatData.section;
                List<int> seatNumbers = seatData.seatNumbers;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$section -',
                          style:
                              const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: seatNumbers.map((seatNumber) {
                                String seatIdentifier = '$section-$seatNumber';
                                bool isSelected =
                                    selectedSeats.contains(seatIdentifier);
                                bool isSelectable = seatType == widget.seatType;
                                int price = seatData.price;
                                int commission = seatData.commissionPrice;

                                return Padding(
                                  padding: const EdgeInsets.only(right: 3.0),
                                  child: GestureDetector(
                                    onTap: isSelectable
                                        ? () {
                                            setState(() {
                                              if (isSelected) {
                                                selectedSeats
                                                    .remove(seatIdentifier);
                                                totalSeatPrice -= price;
                                                commissionPrice -= commission;
                                              } else if (selectedSeats.length <
                                                  widget.ticketCount) {
                                                selectedSeats
                                                    .add(seatIdentifier);
                                                totalSeatPrice += price;
                                                commissionPrice += commission;
                                              }
                                            });
                                          }
                                        : null,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 4.0),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? Colors.lightBlue
                                            : isSelectable
                                                ? Colors.white
                                                : Colors.grey.shade100,
                                        border: Border.all(
                                          color: Colors.blue,
                                          width: 0.5,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(1.0),
                                      ),
                                      child: Text(
                                        seatNumber.toString(),
                                        style: const TextStyle(fontSize: 10),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                  ],
                );
              }).toList(),
            ),
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
