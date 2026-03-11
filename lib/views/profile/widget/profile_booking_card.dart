import 'package:flutter/material.dart';
import '../../../model/profile/profile_res_model.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_string.dart';
import '../../../utils/date_utils.dart';
import 'ticket_qr_sheet.dart';

class BookingCardWidget extends StatelessWidget {
  final ComedyShowBooking show;
  final bool isUpcoming;

  const BookingCardWidget({
    super.key,
    required this.show,
    required this.isUpcoming,
  });

  List<String> get _allSeats => show.bookings
      .expand((b) => b.seats as List)
      .expand((sg) => sg.seats as List)
      .cast<String>()
      .toList();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showTicketQr(context, show),    // ← opens QR sheet
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.bgBorderColor),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryColor.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitleRow(),
            const SizedBox(height: 12),
            Divider(height: 1, color: AppColors.dividerColor),
            const SizedBox(height: 12),
            _buildInfoRow(),
            const SizedBox(height: 12),
            _buildViewTicketHint(),     // ← tap hint at bottom
          ],
        ),
      ),
    );
  }

  Widget _buildTitleRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            show.showTitle,
            style: const TextStyle(
              color: AppColors.primaryColor,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        _StatusBadge(isUpcoming: isUpcoming),
      ],
    );
  }

  Widget _buildInfoRow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _InfoChip(
              icon: Icons.calendar_today_outlined,
              text: getFormattedDate(show.showDate.toString()),
            ),
            const SizedBox(width: 16),
            _InfoChip(
              icon: Icons.access_time_rounded,
              text: show.startTime,
            ),
          ],
        ),
        if (_allSeats.isNotEmpty) ...[
          const SizedBox(height: 8),
          _InfoChip(
            icon: Icons.event_seat_outlined,
            text: 'Seats: ${_allSeats.join(", ")}',
          ),
        ],
      ],
    );
  }

  Widget _buildViewTicketHint() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          'View Ticket',
          style: TextStyle(
            color: AppColors.primaryColor.withOpacity(0.8),
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 3),
        Icon(
          Icons.qr_code_rounded,
          size: 14,
          color: AppColors.primaryColor.withOpacity(0.8),
        ),
      ],
    );
  }
}

// ── Private sub-widgets ────────────────────────────────────────

class _StatusBadge extends StatelessWidget {
  final bool isUpcoming;

  const _StatusBadge({required this.isUpcoming});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isUpcoming
            ? AppColors.secondaryColor.withOpacity(0.1)
            : AppColors.bgBorderColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isUpcoming
              ? AppColors.secondaryColor.withOpacity(0.5)
              : AppColors.dividerColor,
        ),
      ),
      child: Text(
        isUpcoming ? AppString.upcomingTxt : AppString.completedTxt,
        style: TextStyle(
          color: isUpcoming
              ? AppColors.secondaryColor
              : AppColors.paymentTxtColor,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoChip({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: AppColors.paymentTxtColor),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            color: AppColors.paymentTxtColor,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}