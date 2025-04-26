// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketmart/bloc/navigation_bloc.dart';
import 'package:ticketmart/views/home/drawer/home_screen.dart';
// import 'package:awesome_notifications/awesome_notifications.dart';
import 'my_http_overrides.dart';
import 'dart:io';
import 'dart:async';

import 'utils/app_assets.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:firebase_core/firebase_core.dart';

/// Handles background FCM messages.
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   if (kDebugMode) {
//     print('Handling a background message: ${message.messageId}');
//   }
// }

// The  git@github.com:TheFudx/ticketmart_app.git  current Code

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  HttpOverrides.global = MyHttpOverrides();

  // Initialize Awesome Notifications
  // AwesomeNotifications().initialize(
  //   'resource://drawable/res_app_icon',  // Your app icon path
  //   [
  //     NotificationChannel(
  //       channelKey: 'basic_channel',
  //       channelName: 'Basic notifications',
  //       channelDescription: 'Notification channel for basic tests',
  //       defaultColor: const Color(0xFF9D50DD),
  //       ledColor: Colors.white,
  //     )
  //   ],
  // );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ticket Mart',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  // late FirebaseMessaging _messaging;

  @override
  void initState() {
    super.initState();

    // Initialize Firebase Messaging
    // _messaging = FirebaseMessaging.instance;

    // Request permissions for iOS
    // _messaging.requestPermission(
    //   sound: true,
    //   badge: true,
    //   alert: true,
    //   provisional: false,
    // );

    // Handle foreground messages separately from local notifications
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   if (message.notification != null) {
    //     if (kDebugMode) {
    //       print('Received a foreground message: ${message.notification}');
    //     }
    //     // Handle the message or display a custom notification UI if needed
    //   }
    // });

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
      // Show notification when splash screen finishes using AwesomeNotifications
      // AwesomeNotifications().createNotification(
      //   content: NotificationContent(
      //     id: 10,
      //     channelKey: 'basic_channel',
      //     title: 'Welcome to Ticket Mart!',
      //     body: 'Lights, camera, entertainment!',
      //     bigPicture: 'asset://assets/images/notification_image.png',
      //     notificationLayout: NotificationLayout.BigPicture,
      //   ),
      // );

      // Navigate to HomeScreen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => NavigationBloc(),
            child: const HomeScreen(),
          ),
        ),
      );
    });

    // Request notification permissions on iOS (and Android 13+ if needed)
    // AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    //   if (!isAllowed) {
    //     // Request permission to show notifications
    //     AwesomeNotifications().requestPermissionToSendNotifications();
    //   }
    // });
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
