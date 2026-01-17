import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:ticketmart/providers/user_provider.dart';
import 'package:ticketmart/views/Login/splash_screen.dart';
import 'my_http_overrides.dart';
import 'dart:io';
import 'dart:async';

import 'providers/home_provider.dart';
import 'utils/app_string.dart';

// The  git@github.com:TheFudx/ticketmart_app.git  current Code
// updated 7/Jan/2025 v2
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
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: AppString.ticketmart,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
          useMaterial3: true,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
