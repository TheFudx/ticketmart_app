import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ticketmart/model/profile/userprofile_req.dart';
import 'package:ticketmart/services/profile/profile_services.dart';

import '../../model/profile/userprofile_response.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final RxBool isLoading = false.obs;
  final Rxn<UserProfileResp> userProfile = Rxn<UserProfileResp>();

  @override
  void initState() {
    super.initState();
    log('checking');
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    isLoading.value = true;
    try {
      final userReq =
          UserprofileReq(email: 'info@alphastudioz.in', mobileno: '8169886806');

      final response = await ProfileServices.fetchProfile(userReq);
      if (response != null) {
        userProfile.value = response;
      } else {
        Get.snackbar("Error", "Failed to fetch profile data");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Screen'),
      ),
      body: Obx(() {
        if (isLoading.value) {
          // Show loading indicator
          return const Center(child: CircularProgressIndicator());
        }

        if (userProfile.value != null && userProfile.value!.user != null) {
          // Display user profile data
          final user = userProfile.value!.user!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ID: ${user.id}'),
                Text('Email: ${user.email}'),
                Text('Mobile: ${user.mobileNo}'),
                Text('Role: ${user.role ?? 'N/A'}'),
                Text('Created At: ${user.createdAt}'),
              ],
            ),
          );
        }

        // Error or empty state
        return const Center(
          child: Text('No profile data available'),
        );
      }),
      // const Center(
      //   child: Text(
      //     'Profile ',
      //   ),
      // ),
    );
  }
}
