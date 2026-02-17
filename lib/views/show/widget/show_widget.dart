import 'package:flutter/material.dart';

import '../../../model/seat/seat_layout_res.dart';
import '../../../utils/app_assets.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_string.dart';

Widget buildLegendItem(Color color, String label) {
  return Row(
    children: [
      Container(
        width: 14,
        height: 14,
        decoration: BoxDecoration(
          color: color,
          border: Border.all(color: AppColors.bookedSeated, width: 1),
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      const SizedBox(width: 6),
      Text(label),
    ],
  );
}

AppBar seatAppBar(String? text) {
  return AppBar(
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(text!, style: const TextStyle(fontSize: 16)),
        const Text(
          AppString.alphaStud,
          style: TextStyle(fontSize: 10, color: AppColors.txtColor),
        ),
      ],
    ),
  );
}

Widget showTimeDuration({
  required IconData icon,
  required String t1,
  required String t2,
}) {
  return Row(
    children: [
      Icon(icon, color: AppColors.iconColor),
      Text(t1, style: const TextStyle(color: AppColors.iconColor)),
      const Spacer(),
      Text(t2),
    ],
  );
}

Widget h1Txt(String txt) {
  return Text(
    txt,
    style: const TextStyle(color: AppColors.iconColor, fontSize: 15),
  );
}

Widget planTxt1(String txt1) {
  return Text(txt1, style: const TextStyle(fontSize: 11));
}

Widget s1(double h) {
  return SizedBox(height: h);
}

const gap10 = SizedBox(height: 10);
const gap5 = SizedBox(height: 5);

Widget intrinHeight({
  String genre = '',
  String duration = '',
  String language = '',
}) {
  return Container(
    padding: const EdgeInsets.all(7.0),
    margin: const EdgeInsets.all(00.0),
    decoration: BoxDecoration(
      color: AppColors.rowDetailsColor,
      borderRadius: BorderRadius.circular(5),
      border: Border.all(color: AppColors.bgBorderColor),
    ),
    child: IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              children: [
                showTimeDuration(
                  icon: Icons.category,
                  t1: AppString.categoryTxt,
                  t2: genre,
                ),
                showTimeDuration(
                  icon: Icons.timer,
                  t1: AppString.durationTxt,
                  t2: duration,
                ),
              ],
            ),
          ),
          const SizedBox(height: 50, child: VerticalDivider(thickness: 2)),
          Expanded(
            child: Column(
              children: [
                showTimeDuration(
                  icon: Icons.language,
                  t1: AppString.langTxt,
                  t2: language,
                ),
                showTimeDuration(
                  icon: Icons.people_alt,
                  t1: AppString.ageLimitTxt,
                  t2: AppString.age18addTxt,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Color getColorForType(String type) {
  switch (type.toLowerCase()) {
    case AppString.goldTxt:
      return AppColors.goldSeatColor;
    case AppString.silverTxt:
      return AppColors.silverSeatColor;
    case AppString.bronzeTxt:
      return AppColors.bronzeSeatColor;
    case AppString.platinumTxt:
      return AppColors.platinumSeatColor;
    case AppString.diamondTxt:
      return AppColors.diamondSeatColor;
    default:
      return AppColors.colorBlack;
  }
}

bool containId(List<Cseat> seats, int idNumber) {
  return seats.any((seat) => seat.id == idNumber);
}

String getSeatAssests(String type, bool booked, bool seatSelected) {
  switch (type.toLowerCase()) {
    case AppString.goldTxt:
      return booked
          ? AppAssets.bookedSeated
          : seatSelected
              ? AppAssets.selectedSeated
              : AppAssets.goldSeat;

    case AppString.silverTxt:
      return booked
          ? AppAssets.bookedSeated
          : seatSelected
              ? AppAssets.selectedSeated
              : AppAssets.silverSeat;

    case AppString.bronzeTxt:
      return booked
          ? AppAssets.bookedSeated
          : seatSelected
              ? AppAssets.selectedSeated
              : AppAssets.bronzeSeat;

    case AppString.platinumTxt:
      return booked
          ? AppAssets.bookedSeated
          : seatSelected
              ? AppAssets.selectedSeated
              : AppAssets.platinumSeat;

    case AppString.diamondTxt:
      return booked
          ? AppAssets.sofa2
          : seatSelected
              ? AppAssets.sofa3
              : AppAssets.sofa1;

    default:
      return AppAssets.selectedSeated;
  }
}

Map<String, List<Cseat>> groupSeatsByType(List<Cseat> seats) {
  final Map<String, List<Cseat>> grouped = {};

  for (var seat in seats) {
    grouped.putIfAbsent(seat.seatType, () => []);
    grouped[seat.seatType]!.add(seat);
  }

  return grouped;
}

Map<String, String> priceGroup(List<Cseat> seats) {
  final Map<String, String> grouped = {};

  for (var seat in seats) {
    grouped.putIfAbsent(seat.seatType, () => seat.price);
  }
  return grouped;
}

Map<String, List<Cseat>> groupSeatsPrice(List<Cseat> seats) {
  final Map<String, List<Cseat>> grouped = {};
  for (var seat in seats) {
    grouped.putIfAbsent(seat.seatType, () => []).add(seat);
  }
  return grouped;
}

Widget rowDetails() {
  return Container(
    height: 40,
    margin: const EdgeInsets.symmetric(horizontal: 20),
    decoration: BoxDecoration(
      border: Border.all(
        color: AppColors.rowDetailsBroderColor,
      ),
      color: AppColors.rowDetailsColor,
      borderRadius: BorderRadius.circular(5),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          AppAssets.selectedSeated,
          width: 30,
          height: 30,
        ),
        const Text(AppString.selectedTxt),
        const SizedBox(width: 50),
        Image.asset(
          AppAssets.bookedSeated,
          width: 30,
          height: 30,
        ),
        const Text(AppString.bookedTxt),
      ],
    ),
  );
}

String formatMinuToHour(int totalMinutes) {
  final int hours = totalMinutes ~/ 60;
  final int minutes = totalMinutes % 60;

  if (hours > 0 && minutes > 0) {
    return '${hours}h ${minutes}m';
  } else if (hours > 0) {
    return '${hours}h 00m';
  } else if (minutes > 0) {
    return '${minutes}m';
  } else {
    return '0m';
  }
}

/// Reusable Price Row
Widget priceRow(String title, double amount,
    {bool isBold = false,
    Color color = AppColors.paymentTxtColor,
    int amountFixed = 0}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: color,
          ),
        ),
        Text(
          "₹${amount.toStringAsFixed(amountFixed)}",
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: color,
          ),
        ),
      ],
    ),
  );
}

Widget returnValue(String category) {
  switch (category.toLowerCase()) {
    case "gold":
      return const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("🥪 Samosa "),
            Spacer(),
            Text("🍿 Popcorn "),
            Spacer(),
            Text("🥤 Cold Drink")
          ]);

    case "silver":
      return const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [Text("🍿 Popcorn "), Spacer(), Text("🥤 Cold Drink")]);

    case "bronze":
      return const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [Text("🍿 Popcorn "), Spacer(), Text("🥤 Cold Drink")]);

    case "diamond (recliner)":
      return const Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        Text("🍕 Pizza "),
        Text("🥪 Samosa "),
        Text("🍿 Popcorn "),
        Text("🥤 Cold Drink")
      ]);

    case "platinum":
    default:
      return const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [Text("🍿 Popcorn")]);
  }
}

double calculateSeatTypeTotal(List<Cseat> seats) {
  return seats.fold(0, (sum, item) => sum + int.parse(item.price));
}
