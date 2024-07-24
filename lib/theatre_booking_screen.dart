import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ticketmart/ticket_screen.dart';
import 'package:ticketmart/api_connection.dart'; // Import the API connection file

class TheaterBookingScreen extends StatefulWidget {
  final String theatreId;
  final String theaterName;
  final String movieId;
  final String movieTitle;
  final int ticketCount;

  const TheaterBookingScreen({
    super.key,
    required this.theatreId,
    required this.theaterName,
    required this.movieId,
    required this.movieTitle,
    required this.ticketCount,
  });

  @override
  TheaterBookingScreenState createState() => TheaterBookingScreenState();
}

class TheaterBookingScreenState extends State<TheaterBookingScreen> {
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  List<int> selectedSeats = [];
  int totalSeatPrice = 0;
  Map<int, int> seatData = {};

  final Map<int, int> rowPrices = {
    0: 50,
    1: 50,
    2: 150,
    3: 150,
    4: 150,
    5: 150,
    6: 100,
    7: 100,
    8: 100,
    9: 100,
  };

  @override
  void initState() {
    super.initState();
    _fetchSeatData();
  }

  Future<void> _fetchSeatData() async {
    try {
      final screens = await ApiConnection.fetchScreens('');
      setState(() {
        seatData = screens.fold({}, (acc, screen) {
          acc[screen['screen_id']] = screen['seat_count'];
          return acc;
        });
      });
    } catch (e) {
      if (kDebugMode) {
        print('Failed to fetch seat data: $e');
      }
    }
  }

  int calculateTotalSeatPrice() {
    return selectedSeats.fold(0, (totalPrice, seat) {
      int row = seat ~/ 10;
      return totalPrice + (rowPrices[row] ?? 0);
    });
  }

  void _navigateToTicketScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TicketScreen(
          theaterName: widget.theaterName,
          movieTitle: widget.movieTitle,
          selectedDate: _selectedDate,
          selectedTime: _selectedTime,
          seats: selectedSeats,
          totalSeatPrice: calculateTotalSeatPrice(),
        ),
      ),
    );
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Widget _buildDateTimeSelector(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => _selectDate(context),
            child: Container(
              padding: const EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                children: [
                  const Icon(Icons.calendar_today),
                  const SizedBox(height: 5.0),
                  Text(
                    'Date: ${_selectedDate.toLocal()}'.split(' ')[0],
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 20.0),
        Expanded(
          child: GestureDetector(
            onTap: () => _selectTime(context),
            child: Container(
              padding: const EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                children: [
                  const Icon(Icons.access_time),
                  const SizedBox(height: 5.0),
                  Text(
                    'Time: ${_selectedTime.format(context)}',
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSeatLayout() {
  return SingleChildScrollView(
    scrollDirection: Axis.vertical,
    child: Column(
      children: [
        // Curved theater screen
        SizedBox(
          height: 80.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Normal curve line
              Container(
                height: 40.0,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.grey[300]!, Colors.grey],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(50.0),
                    bottomRight: Radius.circular(50.0),
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              // Text below the curve
              const Text(
                'Screen this side',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        // Seat layout
        Container(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              children: List.generate(10, (rowIndex) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(10, (seatIndex) {
                    int seatNumber = rowIndex * 10 + seatIndex;
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
                          totalSeatPrice = calculateTotalSeatPrice();
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.all(3.0), // Reduced margin
                        padding: const EdgeInsets.all(8.0), // Reduced padding
                        decoration: BoxDecoration(
                          color: selectedSeats.contains(seatNumber)
                              ? Colors.redAccent
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Text(
                          '${String.fromCharCode(65 + rowIndex)}${seatIndex + 1}',
                          style: TextStyle(
                            color: selectedSeats.contains(seatNumber)
                                ? Colors.white
                                : Colors.black,
                            fontSize: 10.0, // Reduced font size
                          ),
                        ),
                      ),
                    );
                  }),
                );
              }),
            ),
          ),
        ),
      ],
    ),
  );
}

  Widget _buildSelectedSeatsDisplay() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Selected Seats: ${selectedSeats.map((seat) => '${String.fromCharCode(65 + seat ~/ 10)}${seat % 10 + 1}').join(', ')}',
          style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10.0),
        Text(
          'Total Price: ₹$totalSeatPrice',
          style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
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
            Text(
              'Tickets: ${widget.ticketCount}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(width: 8),
            Text(
              widget.movieId,
              style: const TextStyle(fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                                'Select Date and Time',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20.0),
              _buildDateTimeSelector(context),
              const SizedBox(height: 20.0),
              const Text(
                'Select Seats',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20.0),
              _buildSeatLayout(),
              const SizedBox(height: 20.0),
              _buildSelectedSeatsDisplay(),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () => _navigateToTicketScreen(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 15.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Text(
                  'Proceed to Payment',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
