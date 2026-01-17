import 'package:flutter/material.dart';

import '../utils/app_assets.dart';

void main() {
  runApp(const SeatingApp());
}

class SeatingApp extends StatelessWidget {
  const SeatingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Seating Layout',
      home: Scaffold(
        appBar: AppBar(title: const Text('Seating Layout')),
        body: const SeatingLayout(),
      ),
    );
  }
}

class SeatingLayout extends StatefulWidget {
  const SeatingLayout({super.key});

  @override
  State<SeatingLayout> createState() => _SeatingLayoutState();
}

class _SeatingLayoutState extends State<SeatingLayout> {
  // Track clicked seats
  final List<bool> singleSeats = List.generate(10, (_) => false);
  final List<bool> doubleSeats =
      List.generate(10, (_) => false); // 5 chairs × 2 seats
  final List<bool> sofas = List.generate(3, (_) => false);

  Widget buildSeat(bool isSelected, VoidCallback onTap,
      {String label = "Seat"}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(4),
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isSelected ? Colors.green : Colors.grey[300],
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Center(child: Text(label, style: const TextStyle(fontSize: 10))),
      ),
    );
  }

  Widget buildSofa(bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Image.asset(
        isSelected ? AppAssets.sofa2G : AppAssets.sofa1B,
        width: 100,
        height: 50,
      ),
      /*
      Container(
        margin: const EdgeInsets.all(6),
        width: 100,
        height: 50,
        decoration: BoxDecoration(
          color: isSelected ? Colors.green : Colors.brown[200],
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Center(child: Text("Sofa")),
      ),
      */
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Row 1: 10 single chairs
          const Text("Row 1: Single Chairs"),
          Wrap(
            children: List.generate(singleSeats.length, (index) {
              return buildSeat(singleSeats[index], () {
                setState(() {
                  singleSeats[index] = !singleSeats[index];
                });
              }, label: "${index + 1}");
            }),
          ),
          const SizedBox(height: 20),

          // Row 2: 5 double-seat chairs
          const Text("Row 2: Double Chairs"),
          Wrap(
            children: List.generate(doubleSeats.length, (index) {
              return buildSeat(doubleSeats[index], () {
                setState(() {
                  doubleSeats[index] = !doubleSeats[index];
                });
              }, label: "D${(index ~/ 2) + 1}-${(index % 2) + 1}");
            }),
          ),
          const SizedBox(height: 20),

          // Row 3: 3 sofas
          const Text("Row 3: Sofas"),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(sofas.length, (index) {
              return buildSofa(sofas[index], () {
                setState(() {
                  sofas[index] = !sofas[index];
                });
              });
            }),
          ),
        ],
      ),
    );
  }
}
