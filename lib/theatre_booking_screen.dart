import 'package:flutter/material.dart';
import 'package:ticketmart/ticket_screen.dart';

class TheaterBookingScreen extends StatefulWidget {
  final String theaterName;
  final String movieTitle;

  const TheaterBookingScreen({
    super.key,
    required this.theaterName,
    required this.movieTitle, required int ticketCount,
  });

  @override
  TheaterBookingScreenState createState() => TheaterBookingScreenState();
}

class TheaterBookingScreenState extends State<TheaterBookingScreen> {
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  List<int> selectedSeats = [];
  int totalSeatPrice = 0;


  // Define seat prices for different rows
  final Map<int, int> rowPrices = {
    0: 50, // Rows A to B
    1: 50, // Rows A to B
    2: 150, // Rows C to F
    3: 150, // Rows C to F
    4: 150, // Rows C to F
    5: 150, // Rows C to F
  };

  List<List<SeatStatus>> seats = List.generate(
    6,
    (row) => List.generate(
      10,
      (column) => SeatStatus.available,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
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
              _buildDateSelector(),
              const SizedBox(height: 20.0),
              _buildTimeSelector(),
              const SizedBox(height: 20.0),
              _buildSeatMap(),
              const SizedBox(height: 20.0),
              _buildPriceInfo(),
              const SizedBox(height: 20.0),
              _buildConfirmButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Date',
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(7, (index) {
            final date = DateTime.now().add(Duration(days: index));
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedDate = date;
                });
              },
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: _selectedDate.day == date.day ? Colors.redAccent : Colors.grey,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  children: [
                    Text(
                      ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'][date.weekday - 1],
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      date.day.toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildTimeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Time',
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildTimeButton('10:30 am'),
              _buildTimeButton('12:00 pm'),
              _buildTimeButton('01:20 pm'),
              _buildTimeButton('02:45 pm'),
              _buildTimeButton('03:15 pm'),
              _buildTimeButton('05:10 pm'),
              // Add more time buttons if needed
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimeButton(String time) {
  return GestureDetector(
    onTap: () {
      setState(() {
        _selectedTime = TimeOfDay.fromDateTime(DateTime(
          _selectedDate.year,
          _selectedDate.month,
          _selectedDate.day,
          int.parse(time.split(':')[0]),
          int.parse(time.split(':')[1].split(' ')[0]),
        ));
      });
    },
    child: Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      decoration: BoxDecoration(
        color: _selectedTime.hour == int.parse(time.split(':')[0]) &&
                _selectedTime.minute == int.parse(time.split(':')[1].split(' ')[0])
            ? Colors.redAccent
            : Colors.grey,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Text(
        time,
        style: const TextStyle(color: Colors.white),
      ),
    ),
  );
}

 Widget _buildSeatMap() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Select Seats',
        style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 10),
      Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: Colors.redAccent),
        ),
        child: Column(
          children: List.generate(6, (rowIndex) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(10, (columnIndex) {
                      final seatIndex = rowIndex * 10 + columnIndex;
                      final seatStatus = seats[rowIndex][columnIndex];
                      final seatPrice = rowPrices[rowIndex] ?? 0;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (seatStatus == SeatStatus.available) {
                              seats[rowIndex][columnIndex] = SeatStatus.selected;
                              selectedSeats.add(seatIndex);
                              totalSeatPrice += seatPrice;
                            } else if (seatStatus == SeatStatus.selected) {
                              seats[rowIndex][columnIndex] = SeatStatus.available;
                              selectedSeats.remove(seatIndex);
                              totalSeatPrice -= seatPrice;
                            }
                          });
                        },
                        child: Container(
                          width: 24.0,
                          height: 24.0,
                          margin: const EdgeInsets.all(4.0),
                          decoration: BoxDecoration(
                            color: seatStatus == SeatStatus.available
                                ? Colors.grey
                                : seatStatus == SeatStatus.selected
                                    ? Colors.redAccent
                                    : Colors.black,
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: Center(
                            child: Text(
                              '${String.fromCharCode(65 + rowIndex)}${columnIndex + 1}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12.0,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                // Display price info in the same row
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(
                    'Row ${String.fromCharCode(65 + rowIndex)}: \$seatPrice',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    ],
  );
}

  Widget _buildPriceInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Price Info',
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ...rowPrices.entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(
              '\$${entry.value} (${String.fromCharCode(65 + entry.key)}-${String.fromCharCode(65 + entry.key + 1)})',
              style: const TextStyle(color: Colors.black, fontSize: 16),
            ),
          );
        }),
        const SizedBox(height: 10),
        Text(
          'Total: \$${totalSeatPrice.toString()}',
          style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildConfirmButton() {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TicketScreen(
              theaterName: widget.theaterName,
              movieTitle: widget.movieTitle,
              selectedDate: _selectedDate,
              selectedTime: _selectedTime,
              seats: selectedSeats,
              totalSeatPrice: totalSeatPrice,
            ),
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
      child: Text(
        'Confirm (${selectedSeats.length} seat${selectedSeats.length == 1 ? '' : 's'})',
        style: const TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}

enum SeatStatus {
  available,
  selected,
  booked,
}
