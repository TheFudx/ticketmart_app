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

class TheaterBookingScreenState extends State<TheaterBookingScreen> {
  List<int> selectedSeats = [];
  int totalSeatPrice = 0;
  Map<int, Map<String, dynamic>> seatData = {};

  final Map<int, int> rowPrices = {
    1: 150,
    2: 150,
    3: 150,
    4: 250,
    5: 250,
    6: 250,
    7: 250,
    8: 250,
    9: 350,
    10: 350,
  };

  @override
  void initState() {
    super.initState();
    _fetchSeatData();
  }

  Future<void> _fetchSeatData() async {
    try {
      final screens = await ApiConnection.fetchSeats(int.parse(widget.theatreId));
      setState(() {
        seatData = {
          for (var screen in screens)
            screen['screen_id']: {
              'seat_count': screen['total_seats'],
              'seat_type': _determineSeatType(
                  screen['screen_id']) // Adjust this as needed
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
    if (['D', 'E', 'F', 'G', 'H'].contains(seatLabel)) return 'Executive';
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

  int _seatLabelToNumber(String seatLabel) {
    int rowIndex = seatLabel.codeUnitAt(0) - 65;
    int seatIndex = int.parse(seatLabel.substring(1)) - 1;
    return rowIndex * 10 + seatIndex;
  }

   Widget _buildSeat(int seatNumber, String seatLabel, String seatType) {
    return GestureDetector(
      onTap: () {
        if (_determineSeatType(seatNumber) != widget.seatType) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text('You selection was set to ${widget.seatType} seats.'),
              backgroundColor: Colors.blue.shade500,
            ),
          );
          return;
        }

        setState(() {
          if (selectedSeats.contains(seatNumber)) {
            selectedSeats.remove(seatNumber);
          } else {
            final seatsToSelect = _getConsecutiveSeats(seatNumber, widget.ticketCount);
            if (seatsToSelect.isNotEmpty && seatsToSelect.length == widget.ticketCount) {
              selectedSeats.addAll(seatsToSelect);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Unable to select ${widget.ticketCount} consecutive seats.'),
                  backgroundColor: Colors.blue.shade500,
                ),
              );
            }
          }
          totalSeatPrice = _calculateTotalSeatPrice();
        });
      },
      child: Container(
        margin: const EdgeInsets.all(4.0),
        padding: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          color: selectedSeats.contains(seatNumber)
              ? Colors.lightBlue
              : Colors.white,
          border: Border.all(
            color: selectedSeats.contains(seatNumber)
                ? Colors.white
                : Colors.lightBlue,
            width: 0.5,
          ),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Text(
          seatLabel,
          style: TextStyle(
            color: selectedSeats.contains(seatNumber)
                ? Colors.white
                : Colors.grey.shade600,
            fontSize: 10.0,
          ),
        ),
      ),
    );
  }

  List<int> _getConsecutiveSeats(int startSeat, int count) {
    final row = startSeat ~/ 10;
    final start = startSeat % 10;
    final seats = List.generate(count, (index) => row * 10 + start + index);

    if (seats.any((seat) => selectedSeats.contains(seat) || _determineSeatType(seat) != widget.seatType)) {
      return [];
    }
    return seats;
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
            // Theater and Movie Details
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
            // Spacer for positioning
            const Spacer(),
            // Theater ID
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
                border:
                    Border.all(color: Colors.grey, width: 0.5), // Blue border
                borderRadius:
                    BorderRadius.circular(4.0), // Circular border radius
              ),
              padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 3.0), // Padding inside the container
              child: Text(
                widget.showtime['showtime_start_time'] ?? 'Start Time',
                style: const TextStyle(fontSize: 11, color: Colors.green),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // Movie ID
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
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                  vertical:
                                      4.0), // Padding inside the container
                              child: const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [],
                              ),
                            ),
                            const Spacer(),
                            const Icon(
                              Icons.edit_outlined,
                              size: 12.0,
                              color: Colors.blue,
                            ),
                            const SizedBox(width: 5.0),
                            Text(
                              '${widget.ticketCount} Ticket, ${widget.seatType}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    _buildSeatLayout(),
                    const SizedBox(height: 20.0),
                    _buildSelectedSeatsDisplay(),
                     const SizedBox(height: 20.0),
                    _buildDynamicSeatsDisplay(), 
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
                  // Navigate to ProfilePage
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfilePage(
                              theaterName: 'theatreName',
                              movieTitle: 'movie',
                              seats: [1, 2, 3],
                              totalSeatPrice: 100,
                              email: 'email',
                              phone: 'phone', showTime: {}, seatType: '', theatreId: '', movieId: '',
                            )),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade900,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                ),
                child: const Text(
                  'Proceed to Payment',
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //  Widget _buildDynamicSeatsDisplay() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       const Padding(
  //         padding: EdgeInsets.symmetric(vertical: 10.0),
  //         child: Text(
  //           'Dynamic Seat Sections:',
  //           style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
  //         ),
  //       ),
  //       for (var entry in seatData.entries)
  //         _buildDynamicSeatSection(entry.key as String, entry.value),
  //     ],
  //   );
  // }

  // Widget _buildDynamicSeatSection(String section, Map<String, dynamic> data) {
  //   final seatType = data['seat_type'];
  //   final seatCount = data['seat_count'];
  //   final price = data['price'];

  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 5.0),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(
  //           '$section - $seatType Seats',
  //           style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
  //         ),
  //         Text(
  //           'Total Seats: $seatCount',
  //           style: const TextStyle(fontSize: 12.0),
  //         ),
  //         Text(
  //           'Price per Seat: ₹$price',
  //           style: const TextStyle(fontSize: 12.0),
  //         ),
  //         const SizedBox(height: 10.0),
  //         // Add any additional display logic as needed...
  //       ],
  //     ),
  //   );
  // }

  Widget _buildDynamicSeatsDisplay() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        child: Text(
          'Dynamic Seat Sections:',
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
      ),
      for (var entry in seatData.entries)
        _buildDynamicSeatSection(entry.key as String, entry.value),
    ],
  );
}

Widget _buildDynamicSeatSection(String section, Map<String, dynamic> data) {
  final seatType = data['seat_type'];
  final seats = List<String>.from(data['seats']); // Adjust this based on your API response

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$section - $seatType Seats',
          style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Column(
            children: _buildSeatRows(seats),
          ),
        ),
      ],
    ),
  );
}

List<Widget> _buildSeatRows(List<String> seats) {
  final seatRows = <Widget>[];

  for (var i = 0; i < seats.length; i += 10) {
    final rowSeats = seats.sublist(i, i + 10);
    seatRows.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: rowSeats.map((seatLabel) {
          return Container(
            margin: const EdgeInsets.all(4.0),
            padding: const EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.blue.shade200,
                width: 0.5,
              ),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Text(
              seatLabel,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 10.0,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  return seatRows;
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
