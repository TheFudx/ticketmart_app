import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class BusOperatorDetailsPage extends StatelessWidget {
  final String operatorName;
  final String operatorType;
  final String operatorTime;
  final String operatorRating;
  final String operatorReviews;
  final String operatorSeatsLeft;
  final String operatorDuration;

  const BusOperatorDetailsPage({
    super.key,
    required this.operatorName,
    required this.operatorType,
    required this.operatorTime, 
    required this.operatorRating, 
    required  this.operatorReviews, 
    required  this.operatorSeatsLeft, 
    required  this.operatorDuration,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Seats'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(), // Divider after operator type

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      operatorName,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    const Icon(Icons.star, color: Colors.yellow, size: 20),
                    const SizedBox(width: 5),
                    Text(
                      operatorRating,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Text(
                  operatorType,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
          const Divider(), // Divider after operator type
           Row(
            children: [
              const Padding(padding: EdgeInsets.all(12)),
               const Text(
                'Lower Berth (18)',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 70),
               Text(
                operatorTime,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
                            const SizedBox(width: 70),

              Text(
                operatorDuration,
                style: const TextStyle(fontSize: 14),
              ),

            ],
          ),
          
          const Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 50.0),
                child: Column(
                  children: [
                    SeatLayout(
                      seats: [
                        ['', '', ''],
                        ['', 'F', ''],
                        ['', '', ''],
                        ['', 'F', ''],
                        ['', '', ''],
                        ['', 'F', ''],
                      ],
                      isUpper: false,
                      seatWidth: 50,
                    ),
                    SizedBox(height: 20),
                    SeatLayout(
                      seats: [
                        ['', '', ''],
                        ['', '', ''],
                        ['', 'F', ''],
                      ],
                      isUpper: true,
                      seatWidth: 50,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            height: 70,
            color: Colors.grey[200],
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 18.0),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'COVID safety',
                  style: TextStyle(fontSize: 14,),
                ),
                Text(
                  'Amenities',
                  style: TextStyle(fontSize: 14, ),
                ),
                Text(
                  'Ratings',
                  style: TextStyle(fontSize: 14, ),
                ),
                Text(
                  'Policies',
                  style: TextStyle(fontSize: 14, ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FilterChipWidget extends StatelessWidget {
  final String label;

  const FilterChipWidget({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[300],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(color: Colors.black, fontSize: 14),
        ),
      ),
    );
  }
}

class SeatLayout extends StatefulWidget {
  final List<List<String>> seats;
  final bool isUpper;
  final double seatWidth;

  const SeatLayout({
    super.key,
    required this.seats,
    this.isUpper = false,
    required this.seatWidth,
  });

  @override
  // ignore: library_private_types_in_public_api
  _SeatLayoutState createState() => _SeatLayoutState();
}

class _SeatLayoutState extends State<SeatLayout> {
  final Set<SeatPosition> _selectedSeats = {};

 void _showSeatSelectionBottomSheet(BuildContext context) {
  int totalSeats = _selectedSeats.length;
  double pricePerSeat = 4400.0; // Assuming a fixed price per seat
  double totalPrice = totalSeats * pricePerSeat;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      final screenWidth = MediaQuery.of(context).size.width; // Get screen width
      return Container(
        width: screenWidth, // Set the width of the bottom sheet
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selected Seats: ${_selectedSeats.map((s) => '(${s.row}, ${s.col})').join(', ')}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Total Price: ₹${totalPrice.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _openCheckout(context, totalPrice);
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, 
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text(
                'Pay Now',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      );
    },
  );
}

void _openCheckout(BuildContext context, double totalPrice) {
  var options = {
    'key': 'rzp_test_FZs1ciE3h1febU', // Replace with your Razorpay API key
    'amount': (totalPrice * 100).toInt(), // Amount is in paise
    'name': 'Bus Booking',
    'description': 'Ticket Payment',
    'prefill': {
      'contact': '1234567890',
      'email': 'test@example.com',
    },
    'external': {
      'wallets': ['paytm']
    }
  };

  try {
    Razorpay razorpay = Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, (response) => _handlePaymentSuccess(response, context));
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    
    razorpay.open(options);
  } catch (e) {
    if (kDebugMode) {
      print(e.toString());
    }
  }
}

void _handlePaymentSuccess(PaymentSuccessResponse response, BuildContext context) {
    // Handle successful payment here
    if (kDebugMode) {
      print("Payment successful: ${response.paymentId}");
    }
    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Payment successful: ${response.paymentId}")));
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => BookingConfirmationPage(
        selectedSeats: _selectedSeats.toList(),
        totalPrice: _selectedSeats.length * 4400.0,
      ),
    ));
  }

void _handlePaymentError(PaymentFailureResponse response) {
  // Handle payment error here
  if (kDebugMode) {
    print("Payment failed: ${response.code} - ${response.message}");
  }
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Payment failed: ${response.message}")));
}

void _handleExternalWallet(ExternalWalletResponse response) {
  // Handle external wallet response here
  if (kDebugMode) {
    print("External wallet selected: ${response.walletName}");
  }
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("External wallet selected: ${response.walletName}")));
}


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.isUpper)
          const Text('Upper Berth (9)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Container(
          padding: const EdgeInsets.all(10),
          child: const Row(
            children: [
              FilterChipWidget(label: '₹4,400'),
              
            ],
            
          ),
        ),
        
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.seats.length * widget.seats[0].length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: widget.seats[0].length,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: widget.seatWidth / widget.seatWidth, // Maintain square aspect ratio
          ),
          itemBuilder: (context, index) {
            int row = index ~/ widget.seats[0].length;
            int col = index % widget.seats[0].length;
            String seat = widget.seats[row][col];

            String imageAsset = 'assets/images/seater.png'; // Default seat image path

            if (seat == 'F') {
              imageAsset = 'assets/images/seater.png'; // Female seat image path
            } else if (seat == 'M') {
              imageAsset = 'assets/images/seater.png'; // Male seat image path
            }

            bool isSelected = _selectedSeats.contains(SeatPosition(row, col));

            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _selectedSeats.remove(SeatPosition(row, col));
                  } else {
                    _selectedSeats.add(SeatPosition(row, col));
                  }
                });

                if (_selectedSeats.isNotEmpty) {
                  _showSeatSelectionBottomSheet(context);
                }
              },
              child: Container(
             width: widget.seatWidth * 0.4, // Reduce width by 20%
                height: widget.seatWidth * 0.4, // Reduce height by 20%
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(imageAsset),
                    fit: BoxFit.cover,
                  ),
                  color: isSelected ? Colors.grey : Colors.transparent, // Highlight selected seats
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(
                    color: isSelected ? Colors.grey : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    seat.isNotEmpty ? seat : '',
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class SeatPosition {
  final int row;
  final int col;

  SeatPosition(this.row, this.col);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SeatPosition &&
          runtimeType == other.runtimeType &&
          row == other.row &&
          col == other.col;

  @override
  int get hashCode => row.hashCode ^ col.hashCode;
}


class BookingConfirmationPage extends StatelessWidget {
  final List<SeatPosition> selectedSeats;
  final double totalPrice;

  const BookingConfirmationPage({
    super.key,
    required this.selectedSeats,
    required this.totalPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('Booking Confirmation'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTicketCard(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTicketCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTicketHeader(),
          const Divider(color: Colors.grey),
          _buildTicketDetails(),
          const Divider(color: Colors.grey),
          _buildTicketFooter(),
          _buildTicketBarcode(),
        ],
      ),
    );
  }

  Widget _buildTicketHeader() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15.0),
          topRight: Radius.circular(15.0),
        ),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'E-Ticket',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
          Text(
            'Your journey details',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketDetails() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Selected Seats: ${selectedSeats.map((s) => '(${s.row}, ${s.col})').join(', ')}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            'Total Price: ₹${totalPrice.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          _buildPassengerDetails(),
        ],
      ),
    );
  }

  Widget _buildPassengerDetails() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Passenger Name: John Doe',
          style: TextStyle(fontSize: 14),
        ),
        SizedBox(height: 5),
        Text(
          'Date of Journey: 25th Aug 2024',
          style: TextStyle(fontSize: 14),
        ),
        SizedBox(height: 5),
        Text(
          'Boarding Time: 10:00 AM',
          style: TextStyle(fontSize: 14),
        ),
        SizedBox(height: 5),
        Text(
          'Ticket Number: 123456789',
          style: TextStyle(fontSize: 14),
        ),
        SizedBox(height: 5),
        Text(
          'Seat Type: AC Sleeper',
          style: TextStyle(fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildTicketFooter() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.blueGrey[50],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(15.0),
          bottomRight: Radius.circular(15.0),
        ),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Please be at the boarding point 15 minutes before departure.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          SizedBox(height: 10),
          Text(
            'Enjoy your journey!',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketBarcode() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(25, (index) {
          return Container(
            width: 5,
            height: 40,
            color: index % 2 == 0 ? Colors.black : Colors.transparent,
          );
        }),
      ),
    );
  }
}

// class SeatPosition {
//   final String row;
//   final int col;

//   SeatPosition({required this.row, required this.col});
// }
