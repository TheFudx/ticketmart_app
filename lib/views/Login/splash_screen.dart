import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:ticketmart/views/home/drawer/home_screen.dart';

import '../../providers/user_provider.dart';
import '../../storage/shared_pref_helper.dart';
import '../../utils/app_assets.dart';
import 'login_screen.dart'; // ignore: unused_import

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _animationController.forward();

    Timer(const Duration(seconds: 3), () {
      initial();
    });
  }

  Future<void> initial() async {
    // =========================================================================
    // Authentication Process (Commented out as requested - currently disabled):
    // =========================================================================
    /*
    final user = await SharedPrefHelper.getUser();

    if (user == null) {
      Get.off(() => const LoginScreen());
    } else {
      if (!mounted) return;
      context.read<UserProvider>().setUser(user);
      Get.off(() => const HomeScreen());
    }
    */

    // App opens directly to HomeScreen without requiring authentication:
    final user = await SharedPrefHelper.getUser();
    if (user != null && mounted) {
      context.read<UserProvider>().setUser(user);
    }
    Get.off(() => const HomeScreen());
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: ScaleTransition(
            scale: _animation,
            child: Image.asset(AppAssets.splashScreen),
          ),
        ),
      ),
    );
  }
}
