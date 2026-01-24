import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ticketmart/views/show/booked_seat_detail.dart';

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
  Map<String, String> priGroup = {};

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
      priGroup = priceGroup(data!.stage!.cseats);
    });
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
    bool seatSelected = containId(selectedSeats, seat.id);
    String seatImg = getSeatAssests(seat.seatType, seat.booked, seatSelected);

    double height =
        AppString.diamondTxt == seat.seatType.toLowerCase() ? 30 : 40;
    double width =
        AppString.diamondTxt == seat.seatType.toLowerCase() ? 30 : 20;

    return Column(
      children: [
        const SizedBox(height: 10),
        Text(
          '${seat.section}${seat.seatNumber}',
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: GestureDetector(
            onTap: seat.booked == true ? null : () => onSeatTap(seat),
            child: Image.asset(
              seatImg,
              width: width,
              height: height,
            ),
          ),
        ),
      ],
    );
  }

  Widget seatTypeRow(String type, List<Cseat> seats) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Text(
            type,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: getColorForType(type),
            ),
          ),
        ),
        Wrap(
          children: seats.map(seatWidget).toList(),
        ),
        const SizedBox(height: 10),
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
                    Row(
                      children: priGroup.entries.map(
                        (entry) {
                          return Container(
                            margin: const EdgeInsets.all(4),
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: AppColors.bgBorderColor),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  entry.key,
                                  style: TextStyle(
                                      fontSize: 12.0,
                                      color: getColorForType(entry.key)),
                                ),
                                Text(
                                  "Rs.${entry.value}",
                                  style: const TextStyle(fontSize: 9.0),
                                ),
                              ],
                            ),
                          );
                        },
                      ).toList(),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: Image.asset(AppAssets.stage, height: 130),
                    ),
                    const SizedBox(height: 10),
                    buildSeatLayout(),
                    const SizedBox(height: 10),
                    rowDetails(),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: selectedSeats.isEmpty
                            ? () {}
                            : () {
                                Get.to(
                                  () => BookedSeatDetail(
                                      selectedSeats: selectedSeats,
                                      showTime: data!.show!.showtime[0]),
                                );
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF08538A),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(
                              color: Color(0xFF08538A),
                            ),
                          ),
                        ),
                        child: const Text(
                          AppString.bookNowTxt,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
