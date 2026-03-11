import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../model/profile/profile_res_model.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_text_style.dart';
import '../../../utils/date_utils.dart';

/// Call this to show the ticket QR bottom sheet
void showTicketQr(BuildContext context, ComedyShowBooking show) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => TicketQrSheet(show: show),
  );
}

class TicketQrSheet extends StatelessWidget {
  final ComedyShowBooking show;

  const TicketQrSheet({super.key, required this.show});

  // Build a unique QR data string from booking info
  String get _qrData {
    final bookingIds = show.bookings.map((b) => b.bookingId).join(',');
    return 'SHOW:${show.showTitle}|DATE:${show.showDate}|IDS:$bookingIds';
  }

  List<String> get _allSeats => show.bookings
      .expand((b) => b.seats as List)
      .expand((sg) => sg.seats as List)
      .cast<String>()
      .toList();

  bool get _isUpcoming => isTodayOrFuture(show.showDate);

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.92,
      minChildSize: 0.6,
      maxChildSize: 0.95,
      builder: (_, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            children: [
              _buildDragHandle(),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
                    child: Column(
                      children: [
                        _buildHeader(context),
                        const SizedBox(height: 24),
                        _buildTicketCard(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ── Drag Handle ────────────────────────────────────────────
  Widget _buildDragHandle() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  // ── Sheet Header ───────────────────────────────────────────
  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Your Ticket', style: AppTextStyles.headingMedium),
              const SizedBox(height: 2),
              Text(
                _isUpcoming ? 'Show this QR at entry' : 'Show has ended',
                style: AppTextStyles.bodySmall,
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.close_rounded, size: 18, color: Colors.black54),
          ),
        ),
      ],
    );
  }

  // ── Main Ticket Card ───────────────────────────────────────
  Widget _buildTicketCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.12),
            blurRadius: 24,
            spreadRadius: 0,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildTicketTop(),
          _buildPerforationDivider(),
          _buildTicketBottom(),
        ],
      ),
    );
  }

  // ── Top Section (show info + QR) ───────────────────────────
  Widget _buildTicketTop() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryColor,
            AppColors.primaryColor.withOpacity(0.85),
          ],
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Status badge
          Align(
            alignment: Alignment.topRight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white38),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: _isUpcoming ? Colors.greenAccent : Colors.white54,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _isUpcoming ? 'UPCOMING' : 'COMPLETED',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Show title
          Text(
            show.showTitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 20),

          // QR Code
          _buildQrCode(),

          const SizedBox(height: 16),

          // Scan hint
          Text(
            _isUpcoming
                ? 'Scan at venue entrance'
                : 'This ticket has been used',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQrCode() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          ColorFiltered(
            colorFilter: _isUpcoming
                ? const ColorFilter.mode(Colors.transparent, BlendMode.multiply)
                : ColorFilter.mode(
              Colors.white.withOpacity(0.6),
              BlendMode.srcOver,
            ),
            child: QrImageView(
              data: _qrData,
              version: QrVersions.auto,
              size: 190,
              eyeStyle: QrEyeStyle(
                eyeShape: QrEyeShape.square,
                color: AppColors.primaryColor,
              ),
              dataModuleStyle: QrDataModuleStyle(
                dataModuleShape: QrDataModuleShape.square,
                color: AppColors.primaryColor,
              ),
            ),
          ),
          // Watermark if past show
          if (!_isUpcoming)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey.shade400.withOpacity(0.9),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'USED',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 3,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ── Perforation Divider ────────────────────────────────────
  Widget _buildPerforationDivider() {
    return SizedBox(
      height: 28,
      child: Row(
        children: [
          // Left notch
          Container(
            width: 14,
            height: 28,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: const BorderRadius.horizontal(
                right: Radius.circular(14),
              ),
            ),
          ),
          // Dashed line
          Expanded(
            child: LayoutBuilder(
              builder: (_, constraints) {
                const dashWidth = 8.0;
                const dashSpace = 5.0;
                final count = (constraints.maxWidth / (dashWidth + dashSpace)).floor();
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(count, (_) {
                    return Container(
                      width: dashWidth,
                      height: 1.5,
                      margin: const EdgeInsets.only(right: dashSpace),
                      color: Colors.grey.shade300,
                    );
                  }),
                );
              },
            ),
          ),
          // Right notch
          Container(
            width: 14,
            height: 28,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Bottom Section (ticket details) ───────────────────────
  Widget _buildTicketBottom() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _DetailItem(
                  icon: Icons.calendar_today_outlined,
                  label: 'Date',
                  value: getFormattedDate(show.showDate.toString()),
                ),
              ),
              Container(width: 1, height: 40, color: Colors.grey.shade200),
              Expanded(
                child: _DetailItem(
                  icon: Icons.access_time_rounded,
                  label: 'Time',
                  value: show.startTime,
                ),
              ),
            ],
          ),
          if (_allSeats.isNotEmpty) ...[
            const SizedBox(height: 16),
            Divider(color: Colors.grey.shade200, height: 1),
            const SizedBox(height: 16),
            _DetailItem(
              icon: Icons.event_seat_outlined,
              label: 'Seats',
              value: _allSeats.join(', '),
              fullWidth: true,
            ),
          ],
          const SizedBox(height: 20),
          // Copy booking ID button
          _buildCopyButton(),
        ],
      ),
    );
  }

  Widget _buildCopyButton() {
    final bookingId = show.bookings.isNotEmpty ? show.bookings.first.bookingId : 'N/A';

    return Builder(
      builder: (context) => GestureDetector(
        onTap: () {
          Clipboard.setData(ClipboardData(text: bookingId.toString()));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Booking ID copied!'),
              behavior: SnackBarBehavior.floating,
              backgroundColor: AppColors.primaryColor,
              duration: const Duration(seconds: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withOpacity(0.07),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.primaryColor.withOpacity(0.2)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.copy_rounded, size: 16, color: AppColors.primaryColor),
              const SizedBox(width: 8),
              Text(
                'Booking ID: #$bookingId',
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Reusable Detail Item ───────────────────────────────────────
class _DetailItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool fullWidth;

  const _DetailItem({
    required this.icon,
    required this.label,
    required this.value,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: fullWidth ? 0 : 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: AppColors.primaryColor),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.captionMedium,
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: AppTextStyles.labelLarge,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}