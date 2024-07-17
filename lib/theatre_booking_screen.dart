import 'package:flutter/material.dart';
import 'package:ticketmart/ticket_screen.dart';

class TheaterBookingScreen extends StatefulWidget {
  final String theaterName;
  final String movieTitle;
  // final String imageUrl;

  const TheaterBookingScreen({
    super.key,
    required this.theaterName,
    required this.movieTitle,
    // required this.imageUrl,
  });

  @override
  // ignore: library_private_types_in_public_api
  _TheaterBookingScreenState createState() => _TheaterBookingScreenState();
}

class _TheaterBookingScreenState extends State<TheaterBookingScreen> {
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

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
      appBar: AppBar(
        title: Text('Book Tickets - ${widget.theaterName}'),
        backgroundColor: Colors.redAccent,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Container(
            //   height: 250.0,
            //   decoration: BoxDecoration(
            //     borderRadius: const BorderRadius.only(
            //       bottomLeft: Radius.circular(20.0),
            //       bottomRight: Radius.circular(20.0),
            //     ),
            //     boxShadow: [
            //       BoxShadow(
            //         color: Colors.grey.withOpacity(0.5),
            //         spreadRadius: 3,
            //         blurRadius: 7,
            //         offset: const Offset(0, 3),
            //       ),
            //     ],
            //   ),
            //   child: ClipRRect(
            //     borderRadius: const BorderRadius.only(
            //       bottomLeft: Radius.circular(20.0),
            //       bottomRight: Radius.circular(20.0),
            //     ),
            //     child: Image.network(
            //       widget.imageUrl,
            //       fit: BoxFit.cover,
            //     ),
            //   ),
            // ),
            
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    'Selected Movie',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    widget.movieTitle,
                    style: const TextStyle(
                      fontSize: 20.0,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Theater',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    widget.theaterName,
                    style: const TextStyle(
                      fontSize: 20.0,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 32.0),
                  const Text(
                    'Select Date and Time',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () => _selectDate(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          padding: const EdgeInsets.all(12.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: const Text(
                          'Select Date',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => _selectTime(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          padding: const EdgeInsets.all(12.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: const Text(
                          'Select Time',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32.0),
                  const Text(
                    'Select Seats',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  _buildSeatMap(),
                  const SizedBox(height: 32.0),
                  ElevatedButton(
                    onPressed: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => TicketScreen(
        theaterName: widget.theaterName,
        movieTitle: widget.movieTitle,
        selectedDate: _selectedDate,
        selectedTime: _selectedTime, seats: const [], 
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
                    child: const Text(
                      'Confirm Booking',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeatMap() {
    return Column(
      children: seats.asMap().entries.map((entry) {
        int rowIndex = entry.key;
        List<SeatStatus> rowSeats = entry.value;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: rowSeats.asMap().entries.map((seatEntry) {
              int seatIndex = seatEntry.key;
              SeatStatus seatStatus = seatEntry.value;

              Color seatColor = _getSeatColor(seatStatus);

              return GestureDetector(
                onTap: () {
                  _toggleSeatSelection(rowIndex, seatIndex);
                },
                child: Container(
                  width: 24.0,
                  height: 24.0,
                  margin: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    color: seatColor,
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }

  Color _getSeatColor(SeatStatus seatStatus) {
    switch (seatStatus) {
      case SeatStatus.available:
        return Colors.green;
      case SeatStatus.selected:
        return Colors.yellow;
      case SeatStatus.booked:
        return Colors.grey;
      default:
        return Colors.transparent;
    }
  }

  void _toggleSeatSelection(int rowIndex, int seatIndex) {
    setState(() {
      if (seats[rowIndex][seatIndex] == SeatStatus.available) {
        seats[rowIndex][seatIndex] = SeatStatus.selected;
      } else if (seats[rowIndex][seatIndex] == SeatStatus.selected) {
        seats[rowIndex][seatIndex] = SeatStatus.available;
      }
      // Add logic for handling already booked seats if needed
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)), // Example: Allow booking for 30 days from now
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }
}

enum SeatStatus {
  available,
  selected,
  booked,
}
