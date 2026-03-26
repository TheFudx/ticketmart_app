import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ticketmart/views/profile/widget/profile_booking_category.dart';
import 'package:ticketmart/views/profile/widget/profile_booking_history.dart';
import 'package:ticketmart/views/profile/widget/user_profile_header.dart';

import '../../model/profile/profile_res_model.dart';
import '../../providers/user_provider.dart';
import '../../repository/profile/user_profile.dart';
import '../../utils/app_colors.dart';

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
    final data = await UserProfileRespository.fetchProfile();
    setState(() {
      _shows = data.data.comedyShowsBooking;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    final userMobile = user?.mobile == null ? "" : "+91 ${user!.mobile}";
    final userEmail = user?.email == null ? "" : "${user?.email}";
    return Scaffold(
      backgroundColor: Colors.white,
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
