import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../utils/api_string.dart';
import '../../../../utils/app_assets.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_string.dart';
import '../../../../utils/app_text_style.dart';

AppBar appBar({
  required BuildContext context,
  required ValueChanged<String> onSearch,
}) {
  return AppBar(
    elevation: 1,

      leadingWidth: 90,
    leading: Padding(
      padding: EdgeInsets.only(left: 12.w),
      child: Image.asset(
        AppAssets.logo,
        width: 50.w,
        height: 60.w,
        fit: BoxFit.contain,
      ),
    ),
    title: Text(
      AppString.ticketmart,
      style: AppTextStyles.headingMedium.copyWith(
        fontSize: 20,
        letterSpacing: -0.3,
      ),


    ),

    // actions: [
    //   // ── Search Button ──────────────────────────────────
    //   _SearchButton(onSearch: onSearch),
    //   SizedBox(width: 8.w),
    // ],
  );
}

class _SearchButton extends StatefulWidget {
  final ValueChanged<String> onSearch;
  const _SearchButton({required this.onSearch});

  @override
  State<_SearchButton> createState() => _SearchButtonState();
}

class _SearchButtonState extends State<_SearchButton>
    with SingleTickerProviderStateMixin {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _animController;
  late Animation<double> _widthAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
    _widthAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _openSearch() {
    setState(() => _isSearching = true);
    _animController.forward();
  }

  void _closeSearch() {
    _animController.reverse().then((_) {
      setState(() => _isSearching = false);
      _searchController.clear();
      widget.onSearch('');
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isSearching) {
      return GestureDetector(
        onTap: _openSearch,
        child: Container(
          width: 38.r,
          height: 38.r,
          margin: EdgeInsets.only(right: 4.w),
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withOpacity(0.08),
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.primaryColor.withOpacity(0.15),
            ),
          ),
          child: Icon(
            Icons.search_rounded,
            size: 20.sp,
            color: AppColors.primaryColor,
          ),
        ),
      );
    }

    // Expanded search field
    return SizeTransition(
      sizeFactor: _widthAnim,
      axis: Axis.horizontal,
      child: Container(
        width: 220.w,
        height: 38.h,
        margin: EdgeInsets.only(right: 4.w),
        decoration: BoxDecoration(
          color: AppColors.primaryColor.withOpacity(0.06),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: AppColors.primaryColor.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            SizedBox(width: 10.w),
            Icon(Icons.search_rounded, size: 16.sp, color: AppColors.primaryColor),
            SizedBox(width: 6.w),
            Expanded(
              child: TextField(
                controller: _searchController,
                autofocus: true,
                onChanged: widget.onSearch,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.primaryColor,
                ),
                cursorColor: AppColors.primaryColor,
                decoration: InputDecoration(
                  hintText: 'Search shows...',
                  hintStyle: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.primaryColor.withOpacity(0.4),
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
            GestureDetector(
              onTap: _closeSearch,
              child: Padding(
                padding: EdgeInsets.all(8.r),
                child: Icon(
                  Icons.close_rounded,
                  size: 16.sp,
                  color: AppColors.primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildImageContainer(
  String imagePath, {
  required double width,
  required double height,
}) {
  return InkWell(
    onTap: () {},
    child: Container(
      width: width,
      height: height,
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(8),
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
