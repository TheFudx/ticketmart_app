import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../model/home/home_model.dart';
import '../../../../utils/api_string.dart';
import '../../../../utils/app_assets.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_string.dart';

AppBar appBar({
  required BuildContext context,
}) {
  return AppBar(
    backgroundColor: Colors.white,
    surfaceTintColor: Colors.transparent,
    elevation: 0.5,
    centerTitle: false,
    titleSpacing: 14.w,
    title: Image.asset(
      AppAssets.logo,
      height: 38.h,
      fit: BoxFit.contain,
    ),
    actions: [
      Builder(
        builder: (drawerCtx) => IconButton(
          icon: Container(
            padding: EdgeInsets.all(7.r),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withValues(alpha: 0.07),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.menu_rounded,
              color: AppColors.primaryColor,
              size: 20.sp,
            ),
          ),
          onPressed: () {
            Scaffold.of(drawerCtx).openEndDrawer();
          },
        ),
      ),
      SizedBox(width: 8.w),
    ],
  );
}

Widget buildHomeSearchBar({
  required TextEditingController controller,
  required ValueChanged<String> onChanged,
  required VoidCallback onClear,
}) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 14.w),
    decoration: BoxDecoration(
      color: const Color(0xFFF3F4F6),
      borderRadius: BorderRadius.circular(12.r),
      border: Border.all(color: const Color(0xFFE5E7EB)),
    ),
    child: TextField(
      controller: controller,
      onChanged: onChanged,
      style: TextStyle(
        fontSize: 13.sp,
        fontWeight: FontWeight.w500,
        color: const Color(0xFF111827),
      ),
      decoration: InputDecoration(
        hintText: 'Search comedy shows, events, artists...',
        hintStyle: TextStyle(
          fontSize: 12.sp,
          color: const Color(0xFF9CA3AF),
          fontWeight: FontWeight.w400,
        ),
        prefixIcon: Icon(
          Icons.search_rounded,
          color: AppColors.primaryColor,
          size: 20.sp,
        ),
        suffixIcon: controller.text.isNotEmpty
            ? GestureDetector(
                onTap: onClear,
                child: Icon(
                  Icons.close_rounded,
                  size: 18.sp,
                  color: Colors.grey.shade600,
                ),
              )
            : null,
        border: InputBorder.none,
        contentPadding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 10.w),
        isDense: true,
      ),
    ),
  );
}

Widget buildVerticalPosterBanner({
  VoidCallback? onTap,
}) {
  return Center(
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: InkWell(
        onTap: onTap ?? () {},
        borderRadius: BorderRadius.circular(18.r),
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(
            maxWidth: 390.w,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.16),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18.r),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              AspectRatio(
                aspectRatio: 853 / 1280,
                child: Image.asset(
                  AppAssets.alphaneonPoster,
                  fit: BoxFit.cover,
                ),
              ),

              // Bottom subtle interactive touch pill
              Positioned(
                bottom: 14.h,
                left: 16.w,
                right: 16.w,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 11.h, horizontal: 16.w),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFFB45309),
                        Color(0xFFD97706),
                        Color(0xFFF59E0B),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(30.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.35),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.verified_rounded,
                          color: Colors.white, size: 17.sp),
                      SizedBox(width: 8.w),
                      Text(
                        "TAP TO VIEW INVITATION PASS",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11.5.sp,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Icon(Icons.arrow_forward_rounded,
                          color: Colors.white, size: 15.sp),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  ),
);
}

Widget buildHeroBanner({
  VoidCallback? onTap,
  double? height,
  String? imageUrl,
  String? title,
  String? subtitle,
  String? dateFormatted,
  String? venueName,
}) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 12.w),
    child: InkWell(
      onTap: onTap ?? () {},
      borderRadius: BorderRadius.circular(14.r),
      child: Container(
        height: height ?? 180.h,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14.r),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (imageUrl != null && imageUrl.isNotEmpty)
                CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: const Color(0xFF1E293B),
                    child: const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Image.asset(
                    AppAssets.movieBanner,
                    fit: BoxFit.cover,
                  ),
                )
              else
                Image.asset(
                  AppAssets.movieBanner,
                  fit: BoxFit.cover,
                ),

              // Gradient protection & info overlay if title/date provided
              Positioned(
                top: 10.h,
                left: 10.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.65),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: const Color(0xFFF59E0B).withValues(alpha: 0.6),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.workspace_premium_rounded,
                        color: const Color(0xFFF59E0B),
                        size: 13.sp,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        "VIP INVITATION",
                        style: TextStyle(
                          color: const Color(0xFFFDE68A),
                          fontSize: 9.5.sp,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom subtle indicator bar
              Positioned(
                bottom: 8.h,
                right: 10.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Tap to RSVP / View Pass",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9.5.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.white,
                        size: 9.sp,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget buildCategoryFilterPills({
  required List<String> categories,
  required int selectedIndex,
  required ValueChanged<int> onSelect,
}) {
  return SizedBox(
    height: 36.h,
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      itemCount: categories.length,
      separatorBuilder: (_, __) => SizedBox(width: 8.w),
      itemBuilder: (context, index) {
        final isSelected = index == selectedIndex;
        return GestureDetector(
          onTap: () => onSelect(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primaryColor : Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: isSelected ? AppColors.primaryColor : const Color(0xFFE5E7EB),
                width: 1,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AppColors.primaryColor.withValues(alpha: 0.22),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      )
                    ]
                  : null,
            ),
            alignment: Alignment.center,
            child: Text(
              categories[index],
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? Colors.white : const Color(0xFF4B5563),
              ),
            ),
          ),
        );
      },
    ),
  );
}

Widget buildSectionHeader({
  required String title,
  required String subtitle,
  required int count,
}) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 14.w),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF111827),
                  letterSpacing: -0.3,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(6.r),
          ),
          child: Text(
            "$count Available",
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryColor,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget buildShowCard({
  required ComedyShow show,
  required VoidCallback onTap,
}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(14.r),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Poster Image with Badges ──────────────────────────
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(13.r)),
                  child: CachedNetworkImage(
                    imageUrl: show.imagePath,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.grey.shade100,
                      child: const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey.shade200,
                      child: Icon(
                        Icons.theater_comedy_rounded,
                        color: Colors.grey.shade400,
                        size: 36.sp,
                      ),
                    ),
                  ),
                ),

                // Subtle gradient overlay at the bottom of the poster
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: 40.h,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.55),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),

                // Rating Badge (Top Left)
                Positioned(
                  top: 8.h,
                  left: 8.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.72),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.star_rounded,
                          size: 12.sp,
                          color: const Color(0xFFFFD700),
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          show.rating.isNotEmpty ? show.rating : "4.8",
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Language Badge (Top Right)
                if (show.language.isNotEmpty)
                  Positioned(
                    top: 8.h,
                    right: 8.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withValues(alpha: 0.85),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        show.language,
                        style: TextStyle(
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                // Duration Indicator (Bottom Right)
                if (show.duration > 0)
                  Positioned(
                    bottom: 6.h,
                    right: 8.w,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          size: 11.sp,
                          color: Colors.white,
                        ),
                        SizedBox(width: 3.w),
                        Text(
                          "${show.duration}m",
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          // ── Card Details ──────────────────────────────────────
          Padding(
            padding: EdgeInsets.all(9.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  show.genre.isNotEmpty ? show.genre.toUpperCase() : "COMEDY",
                  style: TextStyle(
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.secondaryColor,
                    letterSpacing: 0.4,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 3.h),
                Text(
                  show.title,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF111827),
                    height: 1.25,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 6.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "From",
                          style: TextStyle(
                            fontSize: 9.sp,
                            color: const Color(0xFF9CA3AF),
                          ),
                        ),
                        Text(
                          "₹${show.price}",
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        "Book",
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget buildShimmerPlaceholder() {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 14.w),
    child: GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 14.h,
        childAspectRatio: 0.62,
      ),
      itemCount: 4,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(13.r)),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.image_outlined,
                      color: Colors.grey.shade300,
                      size: 32.sp,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 50.w,
                      height: 8.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Container(
                      width: double.infinity,
                      height: 12.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 40.w,
                          height: 14.h,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F4F6),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                        Container(
                          width: 40.w,
                          height: 20.h,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F4F6),
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}

Widget buildEmptyState({
  required String query,
  required VoidCallback onReset,
}) {
  return Center(
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 36.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(18.r),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.search_off_rounded,
              size: 40.sp,
              color: AppColors.primaryColor,
            ),
          ),
          SizedBox(height: 14.h),
          Text(
            query.isNotEmpty ? 'No shows found for "$query"' : "No shows available right now",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF111827),
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            query.isNotEmpty
                ? "Try checking your spelling or explore other categories."
                : "Check back later for exciting upcoming events!",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.sp,
              color: const Color(0xFF6B7280),
            ),
          ),
          if (query.isNotEmpty) ...[
            SizedBox(height: 14.h),
            TextButton.icon(
              onPressed: onReset,
              icon: Icon(Icons.refresh_rounded, size: 16.sp),
              label: const Text("Clear Filter"),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primaryColor,
                textStyle: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ],
      ),
    ),
  );
}

Widget buildTrustFeaturesStrip() {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 14.w, vertical: 16.h),
    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 14.h),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12.r),
      border: Border.all(color: const Color(0xFFE5E7EB)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.02),
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _trustItem(Icons.verified_user_outlined, "Verified\nTickets"),
        Container(width: 1, height: 26.h, color: const Color(0xFFE5E7EB)),
        _trustItem(Icons.qr_code_2_rounded, "Instant QR\nEntry"),
        Container(width: 1, height: 26.h, color: const Color(0xFFE5E7EB)),
        _trustItem(Icons.support_agent_rounded, "24/7\nSupport"),
      ],
    ),
  );
}

Widget _trustItem(IconData icon, String label) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 20.sp, color: AppColors.primaryColor),
      SizedBox(width: 6.w),
      Text(
        label,
        style: TextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF374151),
          height: 1.25,
        ),
      ),
    ],
  );
}

Widget buildImageContainer(
  String imagePath, {
  double? width,
  double? height,
  double aspectRatio = 1024 / 341,
  BoxFit fit = BoxFit.cover,
  VoidCallback? onTap,
}) {
  return InkWell(
    onTap: onTap ?? () {},
    child: Container(
      width: width,
      height: height,
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      child: height != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                imagePath,
                width: width,
                height: height,
                fit: fit,
              ),
            )
          : AspectRatio(
              aspectRatio: aspectRatio,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  imagePath,
                  width: width,
                  fit: fit,
                ),
              ),
            ),
    ),
  );
}

void showUpdateDialogBox(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false, // Prevent dismiss on tap outside
    builder: (context) => AlertDialog(
      backgroundColor: Colors.black,
      title: Text(
        AppString.updateRequired,
        style: txtStyle(),
      ),
      content: Text(
        AppString.newVersionText,
        style: txtStyle(),
      ),
      actions: [
        TextButton(
          child: const Text(AppString.update),
          onPressed: () {
            final url = Platform.isAndroid
                ? ApiString.androidStoreUrl
                : ApiString.iosStoreUrl;
            launchURLRed(url);
          },
        ),
        TextButton(
          child: const Text(AppString.exit),
          onPressed: () => exit(0),
        ),
      ],
    ),
  );
}

void launchURLRed(String url) async {
  Uri uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } else {
    log("Could not launch $url");
  }
}

TextStyle txtStyle({color = Colors.white, fontWeight = FontWeight.normal}) {
  return TextStyle(color: color, fontWeight: fontWeight);
}

// About Page
const sectionTitleStyle = TextStyle(
  fontSize: 14.0,
  fontWeight: FontWeight.bold,
  color: Colors.blueAccent,
);

const bodyTextStyle = TextStyle(fontSize: 12.0);

Widget buildSection(String title, String content) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 20.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: sectionTitleStyle),
        const SizedBox(height: 8.0),
        Text(content, style: bodyTextStyle),
      ],
    ),
  );
}

Widget buildSubSection(String subtitle, String content) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(subtitle, style: sectionTitleStyle),
        const SizedBox(height: 4.0),
        Text(content, style: bodyTextStyle),
      ],
    ),
  );
}
