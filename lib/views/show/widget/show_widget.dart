import 'package:flutter/material.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_string.dart';

Widget buildLegend() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      buildLegendItem(AppColors.availableSeated, AppString.availableTxt),
      const SizedBox(width: 12),
      buildLegendItem(AppColors.selectedSeated, AppString.selectedTxt),
      const SizedBox(width: 12),
      buildLegendItem(AppColors.bookedSeated, AppString.bookedTxt),
    ],
  );
}

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
    title: Text(
      text!,
      style: const TextStyle(fontSize: 16),
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
      Icon(
        icon,
        color: AppColors.iconColor,
      ),
      Text(
        t1,
        style: const TextStyle(
          color: AppColors.iconColor,
        ),
      ),
      const Spacer(),
      Text(t2),
    ],
  );
}
