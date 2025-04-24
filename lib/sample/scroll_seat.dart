import 'package:flutter/material.dart';

void main() {
  runApp(const SeatBookingApp());
}

class SeatBookingApp extends StatelessWidget {
  const SeatBookingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Seat Booking',
      home: SeatBookingScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Seat {
  final String row;
  final int number;
  bool isBooked;
  bool isSelected;

  Seat({
    required this.row,
    required this.number,
    this.isBooked = false,
    this.isSelected = false,
  });

  String get label => "$row$number";
}

class SeatBookingScreen extends StatefulWidget {
  @override
  _SeatBookingScreenState createState() => _SeatBookingScreenState();
}

class _SeatBookingScreenState extends State<SeatBookingScreen> {
  // Custom row-to-seat count with some booked seats
  final Map<String, List<Seat>> seatMap = {
    'A': List.generate(6, (i) => Seat(row: 'A', number: i + 1)),
    'B': List.generate(4, (i) => Seat(row: 'B', number: i + 1)),
    'C': List.generate(
        8, (i) => Seat(row: 'C', number: i + 1, isBooked: i == 3)),
    'D': List.generate(7, (i) => Seat(row: 'D', number: i + 1)),
    'E': List.generate(
        5, (i) => Seat(row: 'E', number: i + 1, isBooked: i == 1 || i == 4)),
    'F': List.generate(6, (i) => Seat(row: 'F', number: i + 1)),
    'G': List.generate(8, (i) => Seat(row: 'G', number: i + 1)),
    'H': List.generate(4, (i) => Seat(row: 'H', number: i + 1)),
    'I': List.generate(6, (i) => Seat(row: 'I', number: i + 1)),
    'J': List.generate(
        5, (i) => Seat(row: 'J', number: i + 1, isBooked: i == 0)),
    'K': List.generate(7, (i) => Seat(row: 'K', number: i + 1)),
  };

  void toggleSeat(Seat seat) {
    if (!seat.isBooked) {
      setState(() {
        seat.isSelected = !seat.isSelected;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Seat Booking Layout"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            buildLegend(),
            SizedBox(height: 16),
            ...seatMap.entries
                .map((entry) => buildSeatRow(entry.key, entry.value))
                .toList(),
          ],
        ),
      ),
    );
  }

  Widget buildSeatRow(String rowLabel, List<Seat> seats) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            rowLabel,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 8),
          ...seats.map((seat) => GestureDetector(
                onTap: () => toggleSeat(seat),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: seat.isBooked
                        ? Colors.grey
                        : seat.isSelected
                            ? Colors.green
                            : Colors.white,
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    seat.number.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildLegendItem(Colors.white, "Available"),
        SizedBox(width: 12),
        buildLegendItem(Colors.green, "Selected"),
        SizedBox(width: 12),
        buildLegendItem(Colors.grey, "Booked"),
      ],
    );
  }

  Widget buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: color,
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        SizedBox(width: 6),
        Text(label),
      ],
    );
  }
}
