import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../model/invitation/invitation_model.dart';
import '../../utils/app_assets.dart';

class AlphaneonTicketScreen extends StatelessWidget {
  final InvitationVerifyResponse? verifyResponse;
  final String? guestName;
  final String? companion;

  const AlphaneonTicketScreen({
    super.key,
    this.verifyResponse,
    this.guestName,
    this.companion,
  });

  Widget _buildDottedLine() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 4.5;
        const dashSpace = 3.5;
        final dashCount = (boxWidth / (dashWidth + dashSpace)).floor();
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(dashCount, (_) {
            return const SizedBox(
              width: dashWidth,
              height: 1.0,
              child: DecoratedBox(
                decoration: BoxDecoration(color: Color(0xFFCBD5E1)),
              ),
            );
          }),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final guest = verifyResponse?.guest;
    final card = verifyResponse?.card;
    final event = verifyResponse?.event;

    final displayName = guest?.name.isNotEmpty == true
        ? guest!.name
        : (guestName?.isNotEmpty == true ? guestName! : "Sahil Ghone");

    final rawCategory = guest?.category.isNotEmpty == true
        ? guest!.category
        : "INVITEE";
    final categoryBadge = rawCategory.toUpperCase().contains("GUEST")
        ? rawCategory.toUpperCase()
        : "$rawCategory GUEST";

    final accompanyingGuests = guest?.accompanyingGuests ?? 1;
    final totalHeads = guest?.totalHeads ?? (accompanyingGuests + 1);

    final eventTitle = event?.name.isNotEmpty == true
        ? event!.name
        : "Alphaneon Studioz Slate Revel";

    final organiserName = event?.organiserName.isNotEmpty == true
        ? event!.organiserName
        : "Alphaneon";

    final eventDateFormatted = event?.eventDateFormatted.isNotEmpty == true
        ? event!.eventDateFormatted
        : "Friday, 09 Oct 2026, 04:00 PM";

    final venueName = event?.venueName.isNotEmpty == true
        ? event!.venueName
        : "Alphaneon Studioz";

    final venueAddress = event?.venueAddress.isNotEmpty == true
        ? event!.venueAddress
        : "Naman Midtown, A 202, Senapati Bapat Marg, Dadar West, Mumbai, Maharashtra 400013";

    final dietPreference = guest?.dietPreference?.isNotEmpty == true
        ? guest!.dietPreference!
        : "Veg";

    final qrToken = card?.qrToken ?? '';
    final tokenSnippet = qrToken.isNotEmpty
        ? (qrToken.length > 10
            ? "${qrToken.substring(0, 10).toUpperCase()}..."
            : qrToken.toUpperCase())
        : "CDKIJUDOCQ...";

    final qrData = card?.qrScanVerificationUrl.isNotEmpty == true
        ? card!.qrScanVerificationUrl
        : (card?.qrToken.isNotEmpty == true
            ? card!.qrToken
            : "https://ticketmart.co/invitation/verify");

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 12.h,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // ── 1. Top Header with Back Button & Logo ──
                    Row(
                      children: [
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 16.sp,
                            color: const Color(0xFF64748B),
                          ),
                          onPressed: () => Get.back(),
                        ),
                        Expanded(
                          child: Center(
                            child: Image.asset(
                              AppAssets.logo,
                              height: 30.h,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        SizedBox(width: 20.w), // Balance back button
                      ],
                    ),
                    SizedBox(height: 6.h),

                    // ── 2. VERIFIED INVITATION Gold Badge ────
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 14.w, vertical: 3.5.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF3C7),
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: const Color(0xFFFDE68A),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        "VERIFIED INVITATION",
                        style: TextStyle(
                          color: const Color(0xFFB45309),
                          fontSize: 9.5.sp,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ),
                    SizedBox(height: 6.h),

                    // ── 3. Event Title (Serif Bold) ─────────
                    Text(
                      eventTitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'serif',
                        fontSize: 19.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF0F172A),
                        height: 1.2,
                      ),
                    ),
                    SizedBox(height: 2.h),

                    // ── 4. Subtitle By Organiser ────────────
                    Text(
                      "By $organiserName",
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: const Color(0xFF64748B),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 10.h),

                    // ── 5. Perforated Dotted Divider ─────────
                    _buildDottedLine(),
                    SizedBox(height: 10.h),

                    // ── 6. CORDIALLY INVITED Label ──────────
                    Text(
                      "CORDIALLY INVITED",
                      style: TextStyle(
                        fontSize: 10.sp,
                        letterSpacing: 2.0,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                    SizedBox(height: 4.h),

                    // ── 7. Guest Name ───────────────────────
                    Text(
                      displayName,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF0F172A),
                        letterSpacing: -0.3,
                      ),
                    ),
                    SizedBox(height: 5.h),

                    // ── 8. Red Category Capsule (VVIP GUEST) 
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 14.w, vertical: 3.5.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDC2626),
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Text(
                        categoryBadge,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),

                    // ── 9. Admit Box (Light Blue Border Card) 
                    Container(
                      width: double.infinity,
                      padding:
                          EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F7FF),
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(
                          color: const Color(0xFFBFDBFE),
                          width: 1.1,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.group_rounded,
                                color: const Color(0xFF2563EB),
                                size: 16.sp,
                              ),
                              SizedBox(width: 6.w),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "Admit: ",
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF1E293B),
                                      ),
                                    ),
                                    TextSpan(
                                      text: accompanyingGuests > 0
                                          ? "1 + $accompanyingGuests Companion(s)"
                                          : "1 Person",
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w800,
                                        color: const Color(0xFF2563EB),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            "Total Entry: $totalHeads Person(s)",
                            style: TextStyle(
                              fontSize: 11.5.sp,
                              color: const Color(0xFF64748B),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 12.h),

                    // ── 10. QR Code Box (Blue Bordered Card) 
                    Container(
                      padding: EdgeInsets.all(12.r),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: const Color(0xFF0284C7),
                          width: 2.0,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color:
                                const Color(0xFF0284C7).withValues(alpha: 0.08),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: QrImageView(
                        data: qrData,
                        version: QrVersions.auto,
                        size: 155.r,
                        padding: EdgeInsets.zero,
                        eyeStyle: const QrEyeStyle(
                          eyeShape: QrEyeShape.square,
                          color: Color(0xFF0F172A),
                        ),
                        dataModuleStyle: const QrDataModuleStyle(
                          dataModuleShape: QrDataModuleShape.square,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                    ),
                    SizedBox(height: 7.h),

                    // ── 11. Scan At Gate Token Caption ───────
                    Text(
                      "SCAN AT GATE FOR ENTRY • TOKEN: $tokenSnippet",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 9.sp,
                        letterSpacing: 0.8,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                    SizedBox(height: 12.h),

                    // ── 12. Event Info Card (Date, Venue, Diet) 
                    Container(
                      width: double.infinity,
                      padding:
                          EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: const Color(0xFFE2E8F0),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Date & Time
                          Text(
                            "DATE & TIME",
                            style: TextStyle(
                              fontSize: 9.sp,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.7,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                          SizedBox(height: 3.h),
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_month_rounded,
                                color: const Color(0xFF2563EB),
                                size: 14.sp,
                              ),
                              SizedBox(width: 6.w),
                              Expanded(
                                child: Text(
                                  eventDateFormatted,
                                  style: TextStyle(
                                    fontSize: 12.5.sp,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF0F172A),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 9.h),

                          // Venue
                          Text(
                            "VENUE",
                            style: TextStyle(
                              fontSize: 9.sp,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.7,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                          SizedBox(height: 3.h),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 1.h),
                                child: Icon(
                                  Icons.location_on_rounded,
                                  color: const Color(0xFFEF4444),
                                  size: 14.sp,
                                ),
                              ),
                              SizedBox(width: 6.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      venueName,
                                      style: TextStyle(
                                        fontSize: 12.5.sp,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF0F172A),
                                      ),
                                    ),
                                    SizedBox(height: 2.h),
                                    Text(
                                      venueAddress,
                                      style: TextStyle(
                                        fontSize: 10.5.sp,
                                        color: const Color(0xFF475569),
                                        height: 1.3,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 9.h),

                          // Diet Preference
                          Text(
                            "DIET PREFERENCE",
                            style: TextStyle(
                              fontSize: 9.sp,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.7,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                          SizedBox(height: 3.h),
                          Text(
                            dietPreference,
                            style: TextStyle(
                              fontSize: 12.5.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF0F172A),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 6.h),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
