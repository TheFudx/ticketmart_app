import 'package:flutter/material.dart';

import '../../../model/seat/seat_layout_res.dart';
import '../../../utils/app_assets.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_string.dart';
import '../../../utils/date_utils.dart';
import 'show_widget.dart';

class BookingSummaryCard extends StatelessWidget {
  final Showtimes showTime;
  final Map<String, List<Cseat>> groupSeats;
  const BookingSummaryCard(
      {super.key, required this.showTime, required this.groupSeats});

  @override
  Widget build(BuildContext context) {
    final String date = getFormattedDate(showTime.date);
    final String time = convert12Format(showTime.startTime);
    return Container(
      height: 250,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.rowDetailsBroderColor),
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.all(5.0),
      padding: const EdgeInsets.all(5.0),
      child: Row(
        children: [
          Image.asset(
            AppAssets.comedyBannerImg,
            height: 220,
            width: 110,
            fit: BoxFit.fill,
          ),
          const SizedBox(width: 10.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                gap10,
                const Text("Alpha Comedy Unplugged Season 2"),
                gap10,
                Text("$date, $time"),
                gap5,
                const Divider(height: 0),
                gap5,
                const Text(
                  AppString.seatBook,
                  style: TextStyle(color: AppColors.iconColor),
                ),
                ...groupSeats.entries.map(
                  (entry) {
                    final seats = entry.value;
                    final seatNumbers = seats
                        .map((e) => "${e.section}${e.seatNumber}")
                        .join(",");
                    return Column(
                      children: [
                        gap10,
                        Text(
                          "${entry.key} (${seats.length} Ticket) $seatNumbers",
                          softWrap: true,
                          overflow: TextOverflow.fade,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    );
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
