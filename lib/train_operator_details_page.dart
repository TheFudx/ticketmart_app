import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class TrainOperatorDetailsPage extends StatelessWidget {
  final String operatorName;
  final String operatorType;
  final String operatorTime;
  

  const TrainOperatorDetailsPage({
    super.key,
    required this.operatorName,
    required this.operatorType,
    required this.operatorTime,
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
                Text(
                  operatorName,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  operatorType,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
          const Divider(), // Divider after operator type
          const Text(
            '               Lower Berth (18)',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Amenities',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Ratings',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Policies',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
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
    Razorpay _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, (response) => _handlePaymentSuccess(response, context));
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    
    _razorpay.open(options);
  } catch (e) {
    print(e.toString());
  }
}

void _handlePaymentSuccess(PaymentSuccessResponse response, BuildContext context) {
    // Handle successful payment here
    print("Payment successful: ${response.paymentId}");
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
  print("Payment failed: ${response.code} - ${response.message}");
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Payment failed: ${response.message}")));
}

void _handleExternalWallet(ExternalWalletResponse response) {
  // Handle external wallet response here
  print("External wallet selected: ${response.walletName}");
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
      appBar: AppBar(
        title: const Text('Booking Confirmation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Booked Tickets',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              'Selected Seats: ${selectedSeats.map((s) => '(${s.row}, ${s.col})').join(', ')}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              'Total Price: ₹${totalPrice.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
