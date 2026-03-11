import 'package:flutter/material.dart';
import 'package:ticketmart/views/profile/widget/profile_booking_card.dart';
import '../../../model/profile/profile_res_model.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/date_utils.dart';


class BookingHistoryWidget extends StatelessWidget {
  final List<ComedyShowBooking> shows;

  const BookingHistoryWidget({super.key, required this.shows});

  @override
  Widget build(BuildContext context) {
    final upcomingShows = shows.where((s) => isTodayOrFuture(s.showDate)).toList();
    final pastShows = shows.where((s) => !isTodayOrFuture(s.showDate)).toList();

    if (shows.isEmpty) return _buildEmptyState();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (upcomingShows.isNotEmpty) ...[
          _SectionLabel(label: 'Upcoming', color: AppColors.secondaryColor),
          const SizedBox(height: 10),
          ...upcomingShows.map((s) => BookingCardWidget(show: s, isUpcoming: true)),
          const SizedBox(height: 20),
        ],
        if (pastShows.isNotEmpty) ...[
          _SectionLabel(label: 'Past Bookings', color: AppColors.paymentTxtColor),
          const SizedBox(height: 10),
          ...pastShows.map((s) => BookingCardWidget(show: s, isUpcoming: false)),
        ],
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Column(
          children: [
            Icon(
              Icons.confirmation_number_outlined,
              size: 52,
              color: AppColors.primaryColor.withOpacity(0.3),
            ),
            const SizedBox(height: 12),
            const Text(
              'No bookings yet',
              style: TextStyle(color: AppColors.paymentTxtColor, fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Private sub-widget ─────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;
  final Color color;

  const _SectionLabel({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 13,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.4,
          ),
        ),
      ],
    );
  }
}