import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:ticketmart/views/home/drawer/home_screen.dart';
import 'package:ticketmart/views/profile/widget/profile_booking_category.dart';
import 'package:ticketmart/views/profile/widget/profile_booking_history.dart';
import 'package:ticketmart/views/profile/widget/user_profile_header.dart';

import '../../model/profile/profile_res_model.dart';
import '../../providers/user_provider.dart';
import '../../repository/auth/login.dart';
import '../../repository/profile/user_profile.dart';
import '../../storage/shared_pref_helper.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_string.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  List<ComedyShowBooking> _shows = [];
  bool _isLoading = true;
  int _selectedCategory = 0;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final token = await SharedPrefHelper.getUserToken();
      if (token == null || token.isEmpty) {
        if (mounted) {
          setState(() {
            _shows = [];
            _isLoading = false;
          });
        }
        return;
      }
      final data = await UserProfileRespository.fetchProfile();
      if (mounted) {
        setState(() {
          _shows = data.data.comedyShowsBooking;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _shows = [];
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _showLogoutDialog() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Row(
          children: [
            Icon(Icons.logout_rounded, color: AppColors.secondaryColor),
            SizedBox(width: 10),
            Text(
              'Log Out',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        content: const Text(
          'Are you sure you want to log out?',
          style: TextStyle(fontSize: 14, color: Colors.black87),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      try {
        await LoginRespository.logOut();
      } catch (_) {}
      await SharedPrefHelper.logOut();
      if (mounted) {
        context.read<UserProvider>().clearUser();
      }
      Get.offAll(() => const HomeScreen());
    }
  }

  Widget _buildLogoutTile() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.secondaryColor.withValues(alpha: 0.3),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondaryColor.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: _showLogoutDialog,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.logout_rounded,
                    color: AppColors.secondaryColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Log Out',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.secondaryColor,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Sign out of your account',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: AppColors.secondaryColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    final userMobile = (user?.mobile == null || user!.mobile.isEmpty)
        ? "+91 XXXXXXXXXX"
        : "+91 ${user.mobile}";
    final userEmail = (user?.email == null || user!.email.isEmpty)
        ? "Guest User"
        : user.email;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0.5,
        title: const Text(
          AppString.profileTxt,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryColor,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: AppColors.secondaryColor),
            tooltip: 'Log Out',
            onPressed: _showLogoutDialog,
          ),
        ],
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.primaryColor),
              )
            : RefreshIndicator(
                color: AppColors.primaryColor,
                onRefresh: _loadProfile,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Header ───────────────────────────
                      ProfileHeaderWidget(
                        name: userEmail,
                        phone: userMobile,
                        onEditTap: () {
                          // TODO: Navigate to edit profile
                        },
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 14),

                            // ── Category Tabs ────────────────
                            BookingCategoryTabsWidget(
                              selectedIndex: _selectedCategory,
                              onTabChanged: (index) =>
                                  setState(() => _selectedCategory = index),
                            ),

                            const SizedBox(height: 24),

                            // ── Booking History ──────────────
                            BookingHistoryWidget(shows: _shows),

                            const SizedBox(height: 24),

                            // ── Log Out Option ───────────────
                            _buildLogoutTile(),

                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
