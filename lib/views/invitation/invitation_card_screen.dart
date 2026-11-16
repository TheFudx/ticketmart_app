import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../model/invitation/invitation_model.dart';
import '../../providers/user_provider.dart';
import '../../repository/invitation/invitation_repository.dart';
import '../../storage/shared_pref_helper.dart';
import '../../utils/app_assets.dart';
import 'alphaneon_ticket_screen.dart';
import 'phone_email_dialog.dart';

class InvitationCardScreen extends StatefulWidget {
  final String? eventSlug;
  final InvitationBannerModel? initialBanner;

  const InvitationCardScreen({
    super.key,
    this.eventSlug,
    this.initialBanner,
  });

  @override
  State<InvitationCardScreen> createState() => _InvitationCardScreenState();
}

class _InvitationCardScreenState extends State<InvitationCardScreen> {
  final TextEditingController _mobileController = TextEditingController();

  late String _eventSlug;
  InvitationEventDetails? _eventDetails;
  bool _isLoadingEvent = true;
  String? _errorMessage;

  bool _isVerified = false;
  InvitationVerifyResponse? _verifyResponse;

  @override
  void initState() {
    super.initState();
    _eventSlug = widget.eventSlug ??
        widget.initialBanner?.eventSlug ??
        'alphaneon-studioz-slate-revel-CnXina';
    _loadEventDetails();
    _prefillLoggedUser();
  }

  @override
  void dispose() {
    _mobileController.dispose();
    super.dispose();
  }

  void _prefillLoggedUser() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = context.read<UserProvider>().user;
      if (user != null && user.mobile.isNotEmpty) {
        _mobileController.text = user.mobile;
      }
    });
  }

  Future<void> _loadEventDetails({bool refresh = false}) async {
    if (!refresh) {
      setState(() {
        _isLoadingEvent = true;
        _errorMessage = null;
      });
    }

    try {
      final details = await InvitationRepository.fetchEventDetails(_eventSlug);
      if (mounted) {
        setState(() {
          _eventDetails = details;
          _isLoadingEvent = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = "Unable to load event details.";
          _isLoadingEvent = false;
        });
      }
    }
  }

  void _showNotInvitedDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        elevation: 10,
        backgroundColor: Colors.white,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 24.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(14.r),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF2F2),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFFCA5A5),
                    width: 1.5,
                  ),
                ),
                child: Icon(
                  Icons.person_off_rounded,
                  color: const Color(0xFFDC2626),
                  size: 34.sp,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                "Not on Guest List",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0F172A),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10.h),
              Text(
                message,
                style: TextStyle(
                  fontSize: 12.5.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF475569),
                  height: 1.45,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 22.h),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      child: Text(
                        "Close",
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF475569),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        _openPhoneEmailVerification();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0284C7),
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      child: Text(
                        "Try Another",
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Opens official Phone.email popup modal for mobile & OTP entry
  Future<void> _openPhoneEmailVerification() async {
    final token = await PhoneEmailAuthDialog.show(
      context,
      eventSlug: _eventSlug,
      prefilledPhone: _mobileController.text.trim().isNotEmpty
          ? _mobileController.text.trim()
          : null,
    );

    if (token != null && token.isNotEmpty && mounted) {
      await _processVerifiedToken(token);
    }
  }

  /// Verifies token from Phone.email with TicketMart backend
  Future<void> _processVerifiedToken(String token) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => PopScope(
        canPop: false,
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          backgroundColor: Colors.white,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 20.h),
            child: Row(
              children: [
                SizedBox(
                  width: 32.r,
                  height: 32.r,
                  child: const CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0284C7)),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Verifying Guest List",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        "Retrieving VIP Invitation Pass...",
                        style: TextStyle(
                          fontSize: 11.5.sp,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    try {
      final userJsonUrl = token.startsWith('http')
          ? token
          : 'https://user.phone.email/user_$token.json';

      final response = await InvitationRepository.verifyGuest(
        slug: _eventSlug,
        accessToken: token,
        userJsonUrl: userJsonUrl,
      );

      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }

      if (response.isInvited) {
        final authToken = response.auth?.token;
        if (authToken != null && authToken.isNotEmpty) {
          await SharedPrefHelper.setInvitationToken(authToken);
          await SharedPrefHelper.saveEventSlug(_eventSlug);
        }

        if (mounted) {
          setState(() {
            _isVerified = true;
            _verifyResponse = response;
          });

          Get.to(() => AlphaneonTicketScreen(
                verifyResponse: response,
              ));
        }
      } else {
        if (mounted) {
          _showNotInvitedDialog(
            response.message.isNotEmpty
                ? response.message
                : "Your mobile number was verified successfully, but is not on the guest list for this private event. Please contact the event host.",
          );
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop();
        Get.snackbar(
          "Verification Error",
          "An error occurred while verifying your invitation. Please try again.",
          backgroundColor: Colors.red.shade700,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: EdgeInsets.all(12.r),
        );
      }
    }
  }

  /// Two-step manual SMS fallback verification flow:
  // ignore: unused_element
  void _showVerificationDialog({bool isSms = false}) {
    final user = context.read<UserProvider>().user;
    if (_mobileController.text.isEmpty &&
        user != null &&
        user.mobile.isNotEmpty) {
      _mobileController.text = user.mobile;
    }

    final TextEditingController otpController = TextEditingController();
    bool otpSent = false;
    String? verifiedPhone;
    String? guestName;
    String? debugOtp;
    bool isModalLoading = false;
    String? modalError;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setSheetState) {
          return Container(
            padding: EdgeInsets.only(
              left: 20.w,
              right: 20.w,
              top: 18.h,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top handle
                Center(
                  child: Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),

                // ── HEADER ──────────────────────────────────────────
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(7.r),
                      decoration: BoxDecoration(
                        color: isSms
                            ? const Color(0xFF0284C7).withValues(alpha: 0.1)
                            : const Color(0xFF16A34A).withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        otpSent
                            ? Icons.lock_clock_rounded
                            : (isSms
                                ? Icons.sms_rounded
                                : Icons.chat_bubble_outline_rounded),
                        color: isSms
                            ? const Color(0xFF0284C7)
                            : const Color(0xFF16A34A),
                        size: 20.sp,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Text(
                        otpSent
                            ? "Enter 6-Digit OTP"
                            : (isSms
                                ? "SMS Verification"
                                : "WhatsApp OTP Login"),
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6.h),
                Text(
                  otpSent
                      ? "Enter the 6-digit verification code sent to +91 $verifiedPhone."
                      : (isSms
                          ? "Enter your 10-digit mobile number to receive verification code via SMS."
                          : "Enter your registered WhatsApp mobile number to get the 6-digit access code."),
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: const Color(0xFF64748B),
                    height: 1.35,
                  ),
                ),

                // VIP Guest name badge if recognized in Step 1
                if (otpSent && guestName != null && guestName!.isNotEmpty) ...[
                  SizedBox(height: 10.h),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF3C7),
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: const Color(0xFFFDE68A)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.stars_rounded,
                            size: 14.sp, color: const Color(0xFFB45309)),
                        SizedBox(width: 6.w),
                        Text(
                          "VIP Guest: $guestName",
                          style: TextStyle(
                            fontSize: 11.5.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF92400E),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                if (modalError != null) ...[
                  SizedBox(height: 10.h),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF2F2),
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: const Color(0xFFFCA5A5)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline_rounded,
                            size: 14.sp, color: Colors.red.shade700),
                        SizedBox(width: 6.w),
                        Expanded(
                          child: Text(
                            modalError!,
                            style: TextStyle(
                                fontSize: 11.sp, color: Colors.red.shade800),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                SizedBox(height: 16.h),

                // ── STEP 1: MOBILE NUMBER INPUT ──────────────────────
                if (!otpSent) ...[
                  TextField(
                    controller: _mobileController,
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    autofocus: true,
                    style:
                        TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
                    decoration: InputDecoration(
                      prefixIcon: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        alignment: Alignment.centerLeft,
                        width: 55.w,
                        child: Text(
                          "+91",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                      ),
                      hintText: "Enter 10-digit Mobile Number",
                      hintStyle: TextStyle(
                          fontSize: 13.sp, color: Colors.grey.shade400),
                      counterText: "",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: const BorderSide(
                            color: Color(0xFF0284C7), width: 1.5),
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  SizedBox(
                    width: double.infinity,
                    height: 48.h,
                    child: ElevatedButton(
                      onPressed: isModalLoading
                          ? null
                          : () async {
                              final phone = _mobileController.text.trim();
                              if (phone.length < 10) {
                                setSheetState(() {
                                  modalError =
                                      "Please enter a valid 10-digit mobile number.";
                                });
                                return;
                              }

                              setSheetState(() {
                                isModalLoading = true;
                                modalError = null;
                              });

                              final sendOtpRes =
                                  await InvitationRepository.sendOtp(
                                slug: _eventSlug,
                                phone: phone,
                              );

                              if (!context.mounted) return;

                              if (sendOtpRes.isInvited && sendOtpRes.otpSent) {
                                setSheetState(() {
                                  isModalLoading = false;
                                  otpSent = true;
                                  verifiedPhone = phone;
                                  guestName = sendOtpRes.guestName;
                                  debugOtp = sendOtpRes.debugOtp;
                                });
                              } else {
                                Navigator.pop(ctx);
                                _showNotInvitedDialog(sendOtpRes.message.isNotEmpty
                                    ? sendOtpRes.message
                                    : "Your mobile number is not on the guest list for this private event. Please contact the event host.");
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0284C7),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        elevation: 0,
                      ),
                      child: isModalLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              "Send Verification Code",
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                    ),
                  ),
                ]

                // ── STEP 2: 6-DIGIT OTP INPUT ────────────────────────
                else ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Mobile: +91 $verifiedPhone",
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF334155),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setSheetState(() {
                            otpSent = false;
                            otpController.clear();
                            modalError = null;
                          });
                        },
                        child: Text(
                          "Change",
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0284C7),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  TextField(
                    controller: otpController,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    autofocus: true,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 8,
                      color: const Color(0xFF0F172A),
                    ),
                    decoration: InputDecoration(
                      hintText: "• • • • • •",
                      hintStyle: TextStyle(
                          fontSize: 18.sp,
                          letterSpacing: 4,
                          color: Colors.grey.shade400),
                      counterText: "",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: const BorderSide(
                            color: Color(0xFF0284C7), width: 1.5),
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                    ),
                  ),

                  // Testing hint chip if debug_otp returned
                  if (debugOtp != null && debugOtp!.isNotEmpty) ...[
                    SizedBox(height: 8.h),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          otpController.text = debugOtp!;
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 3.h),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFF6FF),
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(color: const Color(0xFFBFDBFE)),
                          ),
                          child: Text(
                            "Auto-fill OTP: $debugOtp",
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1D4ED8),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],

                  SizedBox(height: 14.h),
                  SizedBox(
                    width: double.infinity,
                    height: 48.h,
                    child: ElevatedButton(
                      onPressed: isModalLoading
                          ? null
                          : () async {
                              final otp = otpController.text.trim();
                              if (otp.length != 6) {
                                setSheetState(() {
                                  modalError =
                                      "Please enter the complete 6-digit OTP code.";
                                });
                                return;
                              }

                              setSheetState(() {
                                isModalLoading = true;
                                modalError = null;
                              });

                              final verifyRes =
                                  await InvitationRepository.verifyOtp(
                                slug: _eventSlug,
                                phone: verifiedPhone!,
                                otp: otp,
                              );

                              if (!context.mounted) return;

                              if (verifyRes.isInvited && verifyRes.status) {
                                Navigator.pop(ctx);

                                setState(() {
                                  _isVerified = true;
                                  _verifyResponse = verifyRes;
                                });

                                if (verifyRes.auth?.token != null &&
                                    verifyRes.auth!.token.isNotEmpty) {
                                  await SharedPrefHelper.setUserToken(
                                      verifyRes.auth!.token);
                                }

                                Get.snackbar(
                                  "VIP Pass Confirmed",
                                  verifyRes.message.isNotEmpty
                                      ? verifyRes.message
                                      : "Welcome! You are on the VIP guest list.",
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: const Color(0xFF16A34A),
                                  colorText: Colors.white,
                                  icon: const Icon(Icons.check_circle_rounded,
                                      color: Colors.white),
                                  margin: EdgeInsets.all(16.r),
                                  duration: const Duration(seconds: 3),
                                );

                                Get.to(() => AlphaneonTicketScreen(
                                      verifyResponse: verifyRes,
                                    ));
                              } else {
                                setSheetState(() {
                                  isModalLoading = false;
                                  modalError = verifyRes.message.isNotEmpty
                                      ? verifyRes.message
                                      : "Invalid OTP code. Please try again.";
                                });
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0284C7),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        elevation: 0,
                      ),
                      child: isModalLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              "Verify & View Pass",
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final title = _eventDetails?.name ??
        widget.initialBanner?.title ??
        "Alphaneon Studioz Slate Revel";
    final organiser = _eventDetails?.organiserName ??
        widget.initialBanner?.organiserName ??
        "Alphaneon";
    final dateFormatted = _eventDetails?.eventDateFormatted ??
        widget.initialBanner?.eventDateFormatted ??
        widget.initialBanner?.eventDate ??
        "Friday, 09 October 2026, 04:00 PM";
    final venueName = _eventDetails?.venueName ??
        widget.initialBanner?.venueName ??
        "Alphaneon Studioz";
    final venueAddress = _eventDetails?.venueAddress ??
        widget.initialBanner?.venueAddress ??
        "Naman Midtown, A 202, Senapati Bapat Marg, Dadar West, Mumbai, Maharashtra 400013";

    return Scaffold(
      backgroundColor: const Color(0xFFF3F6F9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Container(
            padding: EdgeInsets.all(7.r),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: const Color(0xFF0F172A),
              size: 16.sp,
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          color: const Color(0xFF0284C7),
          onRefresh: () => _loadEventDetails(refresh: true),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            child: Center(
              child: Container(
                constraints: BoxConstraints(maxWidth: 420.w),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 26.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24.r),
                  border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (_isLoadingEvent && _eventDetails == null) ...[
                      LinearProgressIndicator(
                        minHeight: 2.h,
                        color: const Color(0xFF0284C7),
                        backgroundColor: const Color(0xFFE0F2FE),
                      ),
                      SizedBox(height: 12.h),
                    ],
                    if (_errorMessage != null && _eventDetails == null) ...[
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.w, vertical: 8.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF2F2),
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(color: const Color(0xFFFCA5A5)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.info_outline_rounded,
                                color: Colors.red.shade700, size: 16.sp),
                            SizedBox(width: 6.w),
                            Expanded(
                              child: Text(
                                _errorMessage!,
                                style: TextStyle(
                                    fontSize: 11.sp,
                                    color: Colors.red.shade800),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => _loadEventDetails(refresh: true),
                              child: Text(
                                "Retry",
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF0284C7),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 12.h),
                    ],

                    // ── 1. TicketMart Logo ───────────────────────────
                    Image.asset(
                      AppAssets.logo,
                      height: 40.h,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: 16.h),

                    // ── 2. Official Invitation Badge (Pill) ──────────
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF3C7),
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: const Color(0xFFFDE68A),
                          width: 1.2,
                        ),
                      ),
                      child: Text(
                        "OFFICIAL INVITATION",
                        style: TextStyle(
                          fontSize: 10.5.sp,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF92400E),
                          letterSpacing: 1.1,
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // ── 3. Title ─────────────────────────────────────
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF0F172A),
                        height: 1.25,
                        letterSpacing: -0.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8.h),

                    // ── 4. Host Subtitle ─────────────────────────────
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF64748B),
                        ),
                        children: [
                          const TextSpan(text: "Cordially hosted by "),
                          TextSpan(
                            text: organiser,
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // ── 5. Stacked Chips (Date & Location) ───────────
                    // Chip A: Date & Time
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: const Color(0xFFE2E8F0),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.calendar_month_outlined,
                            size: 14.sp,
                            color: const Color(0xFF0284C7),
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            dateFormatted,
                            style: TextStyle(
                              fontSize: 11.5.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF334155),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8.h),

                    // Chip B: Venue Name
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: const Color(0xFFE2E8F0),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.location_on_rounded,
                            size: 14.sp,
                            color: const Color(0xFFEF4444),
                          ),
                          SizedBox(width: 5.w),
                          Text(
                            venueName,
                            style: TextStyle(
                              fontSize: 11.5.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF334155),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 28.h),

                    // ── 6. Access Section Title & Subtitle ───────────
                    Text(
                      _isVerified
                          ? "Your Verified VIP Pass"
                          : "Access Your Invitation Card",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF0F172A),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      _isVerified
                          ? "You are confirmed on the private guest list. Present your QR code pass at reception."
                          : "Verify your mobile number via OTP to access and\ndownload your personalized QR entry pass.",
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF64748B),
                        height: 1.45,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 18.h),

                    // ── 7. Verification Container Box ────────────────
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 18.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Column(
                        children: [
                          if (_isVerified && _verifyResponse != null) ...[
                            // Verified pass card indicator
                            GestureDetector(
                              onTap: () => Get.to(() => AlphaneonTicketScreen(
                                    verifyResponse: _verifyResponse,
                                  )),
                              child: Container(
                                margin: EdgeInsets.only(bottom: 12.h),
                                padding: EdgeInsets.all(12.r),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFEF3C7),
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(
                                      color: const Color(0xFFF59E0B)),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.check_circle_rounded,
                                      size: 18.sp,
                                      color: const Color(0xFF16A34A),
                                    ),
                                    SizedBox(width: 8.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${_verifyResponse?.guest?.category ?? 'VIP'} PASS CONFIRMED",
                                            style: TextStyle(
                                              fontSize: 10.sp,
                                              fontWeight: FontWeight.w800,
                                              color: const Color(0xFF92400E),
                                            ),
                                          ),
                                          Text(
                                            _verifyResponse?.guest?.name ??
                                                "VIP Guest",
                                            style: TextStyle(
                                              fontSize: 13.sp,
                                              fontWeight: FontWeight.w700,
                                              color: const Color(0xFF78350F),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 13.sp,
                                      color: const Color(0xFF92400E),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],

                          // ── Main Blue Action Button ─────────────────
                          Container(
                            width: double.infinity,
                            height: 50.h,
                            decoration: BoxDecoration(
                              color: const Color(0xFF0284C7),
                              borderRadius: BorderRadius.circular(12.r),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF0284C7)
                                      .withValues(alpha: 0.35),
                                  blurRadius: 14,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: ElevatedButton.icon(
                              onPressed: () {
                                if (_isVerified) {
                                  Get.to(() => AlphaneonTicketScreen(
                                        verifyResponse: _verifyResponse,
                                      ));
                                } else {
                                  _openPhoneEmailVerification();
                                }
                              },
                              icon: Icon(
                                _isVerified
                                    ? Icons.confirmation_number_rounded
                                    : Icons.call_rounded,
                                size: 18.sp,
                                color: Colors.white,
                              ),
                              label: Text(
                                _isVerified
                                    ? "View Ticket Pass"
                                    : "Login With OTP",
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 14.h),

                          // ── Security text row ───────────────────────
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.shield_outlined,
                                size: 14.sp,
                                color: const Color(0xFF0284C7),
                              ),
                              SizedBox(width: 6.w),
                              Text(
                                "Instant & secure mobile verification",
                                style: TextStyle(
                                  fontSize: 11.5.sp,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),

                          // ── WhatsApp note row ───────────────────────
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.chat_bubble_outline_rounded,
                                size: 14.sp,
                                color: const Color(0xFF16A34A),
                              ),
                              SizedBox(width: 6.w),
                              Flexible(
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    style: TextStyle(
                                      fontSize: 11.sp,
                                      color: const Color(0xFF64748B),
                                      height: 1.3,
                                    ),
                                    children: const [
                                      TextSpan(
                                          text:
                                              "Ticketmart sends the 6-digit verification code to your "),


                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 18.h),

                    // ── 8. Venue Address Box at Bottom ───────────────
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                          horizontal: 14.w, vertical: 12.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.location_on_rounded,
                            size: 16.sp,
                            color: const Color(0xFFEF4444),
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Text(
                              venueAddress,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF475569),
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
