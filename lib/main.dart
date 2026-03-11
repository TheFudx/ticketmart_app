import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:ticketmart/providers/user_provider.dart';
import 'package:ticketmart/utils/app_colors.dart';
import 'package:ticketmart/views/Login/splash_screen.dart';
import 'my_http_overrides.dart';
import 'dart:io';
import 'dart:async';

import 'providers/home_provider.dart';
import 'utils/app_string.dart';

// The  git@github.com:TheFudx/ticketmart_app.git  current Code
// updated 17th/Feb/2026 v2 // Live
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => HomeProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
      ],
      child: ScreenUtilInit(
          designSize: const Size(390, 844),
          minTextAdapt: true,       // Text bhi screen ke saath scale ho
          splitScreenMode: true,    // Tablet split-screen support
          useInheritedMediaQuery: true,
          builder: (context, child) {  return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: AppString.ticketmart,
           theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primaryColor,        // #08538A brand blue
            primary: AppColors.primaryColor,
            secondary: AppColors.secondaryColor,      // #CC2229 brand red
            tertiary: AppColors.accentOrange,         // #F5921E accent
            background: Colors.white,
            surface: Colors.white,
            onPrimary: Colors.white,
            onSecondary: Colors.white,
          ),
          primaryColor: AppColors.primaryColor,
          useMaterial3: true,
        ),
          home: const SplashScreen(),
        );}
      ),
    );
  }
}
