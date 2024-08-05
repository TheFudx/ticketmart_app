import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ticketmart/theatre_booking_screen.dart'; // For date formatting
import 'package:ticketmart/bloc/movie_details_bloc.dart'; // Import the BLoC file
import 'package:flutter/foundation.dart';

class TheatersListScreen extends StatefulWidget {
  final String movieId;
  final String movieTitle;

  const TheatersListScreen({
    super.key,
    required this.movieId,
    required this.movieTitle,
  });

  @override
  State<TheatersListScreen> createState() => _TheatersListScreenState();
}

class _TheatersListScreenState extends State<TheatersListScreen> {
  DateTime _selectedDate = DateTime.now();
  late MovieDetailsBloc _movieDetailsBloc;

  @override
  void initState() {
    super.initState();
    _movieDetailsBloc = MovieDetailsBloc();
    _fetchTheatreCards();
  }

  void _fetchTheatreCards() {
    _movieDetailsBloc.add(
      LoadTheatreCards(
        DateFormat('yyyy-MM-dd').format(_selectedDate),
        widget.movieId,
      ),
    );
  }

   List<Map<String, String>> _getDatesForWeek() {
    final today = DateTime.now();
    return List.generate(7, (index) {
      final date = today.add(Duration(days: index));
      return {
        'day': DateFormat('EEE').format(date),
        'date': DateFormat('dd').format(date),
        'month': DateFormat('MMM').format(date),
        'fullDate': DateFormat('yyyy-MM-dd').format(date),
      };
    });
  }

 DateTime _parseShowtime(String date, String time) {
  try {
    final dateFormat = DateFormat('yyyy-MM-dd h:mm a');
    return dateFormat.parse('$date $time');
  } catch (e) {
    // Handle any parsing errors here
    if (kDebugMode) {
      print('Error parsing date and time: $e');
    }
    return DateTime.now(); // Fallback
  }
}



  @override
  void dispose() {
    _movieDetailsBloc.close();
    super.dispose();
  }

  @override
    Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _movieDetailsBloc,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.movieTitle,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                widget.movieId,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            SizedBox(
              height: 80.0,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: _getDatesForWeek().map((dateInfo) {
                  final isSelected = dateInfo['fullDate'] ==
                      DateFormat('yyyy-MM-dd').format(_selectedDate);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedDate = DateTime.parse(dateInfo['fullDate']!);
                      });
                      _fetchTheatreCards();
                    },
                    child: Container(
                      width: 51.0,
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      padding: const EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blue : Colors.blue[50],
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                          color: isSelected ? Colors.blue : Colors.grey[200]!,
                          width: 0.0,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            dateInfo['day']!,
                            style: TextStyle(
                                color: isSelected ? Colors.white : Colors.blue,
                                fontSize: 11),
                          ),
                          Text(
                            dateInfo['date']!,
                            style: TextStyle(
                                color: isSelected ? Colors.white : Colors.blue,
                                fontSize: 11),
                          ),
                          Text(
                            dateInfo['month']!,
                            style: TextStyle(
                                color: isSelected ? Colors.white : Colors.blue,
                                fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            Expanded(
              child: BlocBuilder<MovieDetailsBloc, MovieDetailsState>(
                builder: (context, state) {
                  if (state is MovieDetailsInitial) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is TheatreCardsLoaded) {
                    final theatres = state.theatreCards;
                    return SingleChildScrollView(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          const SizedBox(height: 10.0),
                          ...theatres
                              .map<Widget>((theatre) => _buildTheaterCard(
                                    theatre['cinema_name'] ?? '',
                                    theatre['cinema_location'] ?? '',
                                    theatre['cinema_id'] ?? '',
                                    theatre['screen_id'] ?? '',
                                    theatre['showtimes'] ?? [],
                                  )),
                        ],
                      ),
                    );
                  } else if (state is TheatreCardsError) {
                    return Center(child: Text(state.message));
                  } else {
                    return const Center(child: Text('Something went wrong'));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTheaterCard(
  String theaterName,
  String city,
  String cinemaId,
  String screenId,
  List<dynamic> showtimes,
) {
  // Get current time and date
  final now = DateTime.now();
  final nowDate = DateTime(now.year, now.month, now.day, now.hour, now.minute); // Current date and time

  // Filter showtimes to include only those on the selected date
  final filteredShowtimes = showtimes.where((showtime) {
    final showtimeDate = DateFormat('yyyy-MM-dd').format(
      DateTime.parse(showtime['showtime_date']),
    );
    return showtimeDate == DateFormat('yyyy-MM-dd').format(_selectedDate);
  }).toList();

  return Card(
    elevation: 5.0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    color: Colors.grey.shade100,
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    theaterName,
                    style: const TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Text(
                    city,
                    style: const TextStyle(
                      fontSize: 14.0,
                    ),
                  ),
                ],
              ),
              if (filteredShowtimes.isNotEmpty)
                Row(
                  children: [
                    Text(
                      DateFormat('yyyy-MM-dd').format(_selectedDate),
                      style: const TextStyle(
                        fontSize: 12.0,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 8.0),
          if (filteredShowtimes.isEmpty)
            Center(
              child: Text(
                'No shows available',
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.blue.shade700,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          else
            Row(
              children: [
                const SizedBox(width: 10),
                Expanded(
                  child: Wrap(
                    spacing: 8.0, // Horizontal spacing between items
                    runSpacing: 4.0, // Vertical spacing between lines
                    children: filteredShowtimes.map<Widget>((showtime) {
                      final showtimeStart = showtime['showtime_start_time'];
                      final showtimeDateTime = _parseShowtime(
                        DateFormat('yyyy-MM-dd').format(_selectedDate),
                        showtimeStart,
                      );
                      final isPast = showtimeDateTime.isBefore(nowDate); // Updated comparison

                      return GestureDetector(
                        onTap: isPast ? null : () => _showSeatSelectionBottomSheet(showtime, cinemaId, theaterName),
                        child: Container(
                          width: 65,
                          margin: const EdgeInsets.only(bottom: 2.0),
                          padding: const EdgeInsets.all(3.0),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isPast ? Colors.grey.shade400 : Colors.green.shade400,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(2.0),
                            color: isPast ? Colors.grey.shade300 : Colors.white,
                          ),
                          child: Center(
                            child: Text(
                              showtimeStart,
                              style: TextStyle(
                                color: isPast ? Colors.grey.shade600 : Colors.green,
                                fontSize: 12.0,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
        ],
      ),
    ),
  );
}

  Widget _buildSeatImages(int numberOfSeats) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(numberOfSeats, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0),
          child: Image.asset(
            'assets/images/Untitled design (59).png',
            width: 35,
            height: 100,
          ),
        );
      }),
    );
  }

void _showSeatSelectionBottomSheet(
    dynamic showtime, String cinemaId, String theaterName) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      int selectedSeats = 1;
      String selectedSeatType = 'Normal';

      return StatefulBuilder(
        builder: (context, setState) {
          return Container(
            width: double.infinity,
            height: 600, // Increased height to accommodate new elements
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                const Text(
                  'Select Seats',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10.0),
                // Display seat images
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  switchInCurve: Curves.easeInOut,
                  switchOutCurve: Curves.easeInOut,
                  child: _buildSeatImages(selectedSeats),
                ),
                const SizedBox(height: 10.0),
                // Container for circular numbers
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  alignment: WrapAlignment.center,
                  children: List.generate(10, (index) {
                    final number = index + 1;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedSeats = number;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        width: 25,
                        height: 25,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: selectedSeats == number
                                ? Colors.blue.shade900
                                : Colors.transparent,
                            width: 2.0,
                          ),
                          color: selectedSeats == number
                              ? Colors.blue.shade900
                              : Colors.grey.shade300,
                        ),
                        child: Center(
                          child: Text(
                            '$number',
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              color: selectedSeats == number
                                  ? Colors.white
                                  : Colors.grey.shade800,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 20.0),
                const Divider(color: Colors.grey),
                const SizedBox(height: 20.0),
                // Row of three containers for seat types
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildSeatTypeOption(
                      'Normal',
                      Colors.blue.shade900,
                      selectedSeatType,
                      () {
                        setState(() {
                          selectedSeatType = 'Normal';
                        });
                      },
                    ),
                    _buildSeatTypeOption(
                      'Executive',
                      Colors.green.shade700,
                      selectedSeatType,
                      () {
                        setState(() {
                          selectedSeatType = 'Executive';
                        });
                      },
                    ),
                    _buildSeatTypeOption(
                      'Premium',
                      Colors.red.shade700,
                      selectedSeatType,
                      () {
                        setState(() {
                          selectedSeatType = 'Premium';
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    // Print statements for debugging
                    if (kDebugMode) {
                      print('Navigating to TheaterBookingScreen with the following details:');
                      print('Showtime: $showtime');
                      print('Theatre ID: $cinemaId');
                      print('Theater Name: $theaterName');
                      print('Movie ID: ${widget.movieId}');
                      print('Movie Title: ${widget.movieTitle}');
                      print('Ticket Count: $selectedSeats');
                      print('Seat Type: $selectedSeatType');
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TheaterBookingScreen(
                          showtime: showtime,
                          theatreId: cinemaId,
                          theaterName: theaterName,
                          movieId: widget.movieId,
                          movieTitle: widget.movieTitle,
                          ticketCount: selectedSeats,
                          seatType: selectedSeatType, // Pass selected seat type
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue.shade900,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 150.0,
                      vertical: 10.0,
                    ),
                  ),
                  child: const Text('Proceed', style: TextStyle(fontSize: 14)),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

Widget _buildSeatTypeOption(String title, Color color, String selectedSeatType, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: selectedSeatType == title ? color : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: selectedSeatType == title ? Colors.transparent : Colors.grey,
          width: 2.0,
        ),
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
            color: selectedSeatType == title ? Colors.white : Colors.black,
          ),
        ),
      ),
    ),
  );
}



Widget _buildTicketOption(String title, String price, String availability) {
  return Container(
    padding: const EdgeInsets.all(8.0),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey),
      borderRadius: BorderRadius.circular(8.0),
    ),
    child: Column(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4.0),
        Text(
          price,
          style: const TextStyle(fontSize: 12.0, color: Colors.grey),
        ),
        const SizedBox(height: 4.0),
        Text(
          availability,
          style: TextStyle(
            fontSize: 12.0,
            color: availability == 'Filling fast' ? Colors.orange : Colors.green,
          ),
        ),
      ],
    ),
  );
}
}
 





