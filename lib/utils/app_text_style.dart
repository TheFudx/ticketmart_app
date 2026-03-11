import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_colors.dart';

/// Usage: AppTextStyles.headingLarge
/// Override: AppTextStyles.headingLarge.copyWith(color: Colors.white)
///
/// All font sizes use .sp  → scales with screen size via ScreenUtil
/// All spacing uses   .w / .h → scales width/height

class AppTextStyles {
  AppTextStyles._();

  // ─── Colors ────────────────────────────────────────────────
  static const Color _black      = Color(0xFF111827);
  static const Color _darkGray   = Color(0xFF374151);
  static const Color _mediumGray = Color(0xFF6B7280);
  static const Color _lightGray  = Color(0xFF9CA3AF);
  static const Color _subtleGray = Color(0xFFD1D5DB);

  // ═══════════════════════════════════════════════════════════
  // DISPLAY
  // ═══════════════════════════════════════════════════════════

  static TextStyle get displayLarge => TextStyle(
    fontSize: 36.sp,
    fontWeight: FontWeight.w800,
    color: _black,
    letterSpacing: -1.0,
    height: 1.15,
  );

  static TextStyle get displayMedium => TextStyle(
    fontSize: 30.sp,
    fontWeight: FontWeight.w700,
    color: _black,
    letterSpacing: -0.8,
    height: 1.2,
  );

  static TextStyle get displaySmall => TextStyle(
    fontSize: 26.sp,
    fontWeight: FontWeight.w700,
    color: _black,
    letterSpacing: -0.5,
    height: 1.25,
  );

  // ═══════════════════════════════════════════════════════════
  // HEADING
  // ═══════════════════════════════════════════════════════════

  static TextStyle get headingLarge => TextStyle(
    fontSize: 22.sp,
    fontWeight: FontWeight.w700,
    color: _black,
    letterSpacing: -0.3,
    height: 1.3,
  );

  static TextStyle get headingMedium => TextStyle(
    fontSize: 19.sp,
    fontWeight: FontWeight.w600,
    color: _black,
    letterSpacing: -0.2,
    height: 1.35,
  );

  static TextStyle get headingSmall => TextStyle(
    fontSize: 17.sp,
    fontWeight: FontWeight.w600,
    color: _black,
    letterSpacing: -0.1,
    height: 1.4,
  );

  // ═══════════════════════════════════════════════════════════
  // TITLE
  // ═══════════════════════════════════════════════════════════

  static TextStyle get titleLarge => TextStyle(
    fontSize: 15.sp,
    fontWeight: FontWeight.w700,
    color: _black,
    height: 1.4,
  );

  static TextStyle get titleMedium => TextStyle(
    fontSize: 15.sp,
    fontWeight: FontWeight.w600,
    color: _darkGray,
    height: 1.4,
  );

  static TextStyle get titleSmall => TextStyle(
    fontSize: 13.sp,
    fontWeight: FontWeight.w600,
    color: _darkGray,
    letterSpacing: 0.1,
    height: 1.4,
  );

  // ═══════════════════════════════════════════════════════════
  // BODY
  // ═══════════════════════════════════════════════════════════

  static TextStyle get bodyLarge => TextStyle(
    fontSize: 17.sp,
    fontWeight: FontWeight.w400,
    color: _darkGray,
    letterSpacing: 0.1,
    height: 1.6,
  );

  static TextStyle get bodyMedium => TextStyle(
    fontSize: 15.sp,
    fontWeight: FontWeight.w400,
    color: _darkGray,
    letterSpacing: 0.1,
    height: 1.6,
  );

  static TextStyle get bodySmall => TextStyle(
    fontSize: 13.sp,
    fontWeight: FontWeight.w400,
    color: _mediumGray,
    letterSpacing: 0.1,
    height: 1.55,
  );

  // ═══════════════════════════════════════════════════════════
  // LABEL
  // ═══════════════════════════════════════════════════════════

  static TextStyle get labelLarge => TextStyle(
    fontSize: 13.sp,
    fontWeight: FontWeight.w600,
    color: _darkGray,
    letterSpacing: 0.4,
    height: 1.4,
  );

  static TextStyle get labelMedium => TextStyle(
    fontSize: 13.sp,
    fontWeight: FontWeight.w500,
    color: _mediumGray,
    letterSpacing: 0.3,
    height: 1.4,
  );

  static TextStyle get labelSmall => TextStyle(
    fontSize: 11.sp,
    fontWeight: FontWeight.w500,
    color: _mediumGray,
    letterSpacing: 0.5,
    height: 1.4,
  );

  // ═══════════════════════════════════════════════════════════
  // CAPTION
  // ═══════════════════════════════════════════════════════════

  static TextStyle get captionLarge => TextStyle(
    fontSize: 13.sp,
    fontWeight: FontWeight.w400,
    color: _lightGray,
    letterSpacing: 0.2,
    height: 1.5,
  );

  static TextStyle get captionMedium => TextStyle(
    fontSize: 11.sp,
    fontWeight: FontWeight.w400,
    color: _lightGray,
    letterSpacing: 0.3,
    height: 1.5,
  );

  static TextStyle get captionSmall => TextStyle(
    fontSize: 11.sp,
    fontWeight: FontWeight.w300,
    color: _subtleGray,
    letterSpacing: 0.3,
    height: 1.5,
  );

  // ═══════════════════════════════════════════════════════════
  // BUTTON
  // ═══════════════════════════════════════════════════════════

  static TextStyle get buttonLarge => TextStyle(
    fontSize: 17.sp,
    fontWeight: FontWeight.w700,
    color: _black,
    letterSpacing: 0.3,
    height: 1.2,
  );

  static TextStyle get buttonMedium => TextStyle(
    fontSize: 15.sp,
    fontWeight: FontWeight.w600,
    color: _black,
    letterSpacing: 0.3,
    height: 1.2,
  );

  static TextStyle get buttonSmall => TextStyle(
    fontSize: 13.sp,
    fontWeight: FontWeight.w600,
    color: _black,
    letterSpacing: 0.4,
    height: 1.2,
  );

  // ═══════════════════════════════════════════════════════════
  // SPECIAL
  // ═══════════════════════════════════════════════════════════

  static TextStyle get overline => TextStyle(
    fontSize: 11.sp,
    fontWeight: FontWeight.w600,
    color: _mediumGray,
    letterSpacing: 1.5,
    height: 1.4,
  );

  static TextStyle get link => TextStyle(
    fontSize: 15.sp,
    fontWeight: FontWeight.w500,
    color: _darkGray,
    letterSpacing: 0.1,
    height: 1.5,
    decoration: TextDecoration.underline,
    decorationColor: Color(0xFF9CA3AF),
    decorationStyle: TextDecorationStyle.dashed,
  );

  static TextStyle get placeholder => TextStyle(
    fontSize: 15.sp,
    fontWeight: FontWeight.w400,
    color: _subtleGray,
    letterSpacing: 0.1,
    height: 1.5,
  );
}