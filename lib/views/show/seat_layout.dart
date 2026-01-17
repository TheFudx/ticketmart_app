import 'package:flutter/material.dart';

import '../../model/seat/seat_layout_res.dart';
import '../../providers/seat_layout_provider.dart';
import '../../utils/app_assets.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_string.dart';
import 'widget/show_widget.dart';

class SeatLayout extends StatefulWidget {
  final int id;
  final int showtimeId;
  final int stageId;

  const SeatLayout(this.id, this.showtimeId, this.stageId, {super.key});

  @override
  State<SeatLayout> createState() => _SeatLayoutState();
}

class _SeatLayoutState extends State<SeatLayout> {
  SeatData? data;
  final List<Cseat> selectedSeats = [];

  @override
  void initState() {
    super.initState();
    apiCall(widget.id, widget.showtimeId, widget.stageId);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> apiCall(int id, int showtimeId, int stageId) async {
    final res = await SeatLayoutProvider.seatLayout(id, showtimeId, stageId);
    setState(() {
      data = res;
    });
  }

  Map<String, List<Cseat>> groupSeatsByType(List<Cseat> seats) {
    final Map<String, List<Cseat>> grouped = {};

    for (var seat in seats) {
      grouped.putIfAbsent(seat.seatType, () => []);
      grouped[seat.seatType]!.add(seat);
    }
    return grouped;
  }

  void onSeatTap(Cseat seat) {
    if (seat.booked == true) return;

    setState(() {
      if (selectedSeats.contains(seat)) {
        selectedSeats.remove(seat);
      } else {
        selectedSeats.add(seat);
      }
    });
  }

  // Seat UI
  Widget seatWidget(Cseat seat) {
    final bool isSelected = selectedSeats.contains(seat);

    Color bgColor;
    if (seat.booked == true) {
      bgColor = AppColors.bookedSeated;
    } else if (isSelected) {
      bgColor = AppColors.selectedSeated;
    } else {
      bgColor = AppColors.availableSeated;
    }

    return GestureDetector(
      onTap: seat.booked == true ? null : () => onSeatTap(seat),
      child: Container(
        width: 42,
        height: 42,
        margin: const EdgeInsets.all(4),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(6),
            border: BoxBorder.all(
              color: seat.booked
                  ? AppColors.bookedSeated
                  : AppColors.selectedSeated,
            )),
        child: Text(
          '${seat.section}${seat.seatNumber}',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget seatTypeRow(String type, List<Cseat> seats) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              type,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 5),
            Text(
              "${seats[0].price}₹",
              style: const TextStyle(fontSize: 9),
            ),
          ],
        ),
        const Divider(),
        Wrap(
          children: seats.map(seatWidget).toList(),
        ),
        const SizedBox(height: 14),
      ],
    );
  }

  Widget buildSeatLayout() {
    final seats = data!.stage!.cseats;

    if (data == null || data!.stage == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final groupedSeats = groupSeatsByType(seats);

    return Column(
      children: groupedSeats.entries
          .map((entry) => seatTypeRow(entry.key, entry.value))
          .toList(),
    );
  }

  Widget selectedSeatSummary() {
    final totalAmount = selectedSeats.fold(
      0,
      (sum, seat) => sum + int.parse(seat.price),
    );

    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${AppString.selectedSeatsTxt}: ${selectedSeats.map((e) => '${e.section}${e.seatNumber}').join(', ')}',
          ),
          const SizedBox(height: 4),
          Text('${AppString.totalSeatsTxt}: ${selectedSeats.length}'),
          const SizedBox(height: 4),
          Text(
            '${AppString.totalAmountTxt}: ₹$totalAmount',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: seatAppBar(data?.show?.title ?? ''),
      body: data == null
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Image.asset(AppAssets.stage, height: 100),
                    ),
                    const SizedBox(height: 10),

                    const SizedBox(height: 10),
                    buildLegend(),
                    const SizedBox(height: 10),

                    /// Seat Layout
                    buildSeatLayout(),

                    /// Selected summary
                    selectedSeatSummary(),

                    const SizedBox(height: 20),

                    Center(
                      child: ElevatedButton(
                          onPressed: () {}, child: const Text('Book Now')),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
