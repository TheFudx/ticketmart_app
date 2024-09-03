import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketmart/bloc/navigation_bloc.dart';
import 'package:ticketmart/home_screen.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'my_http_overrides.dart';
import 'dart:io';
import 'dart:async';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();

  // Initialize Awesome Notifications
  AwesomeNotifications().initialize(
    'resource://drawable/res_app_icon',  // Your app icon path
    [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic notifications',
        channelDescription: 'Notification channel for basic tests',
        defaultColor: const Color(0xFF9D50DD),
        ledColor: Colors.white,
      )
    ],
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ticket Mart',
      theme: ThemeData(
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

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
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
      // Show notification when splash screen finishes
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 10,  // Unique ID for this notification
          channelKey: 'basic_channel',  // Channel key created in the initialization
          title: 'Welcome to Ticket Mart!',
          body: 'Lights, camera, entertainment!',
          bigPicture: 'asset://assets/images/notification_image.png',  // Optional: Add a big picture
          notificationLayout: NotificationLayout.BigPicture,  // Use BigPicture layout
        ),
      );

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
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        // Request permission to show notifications
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
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
            child: Image.asset('assets/images/splash_image.png'),
          ),
        ),
      ),
    );
  }
}
