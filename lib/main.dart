import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_screen.dart';
import 'bloc/navigation_bloc.dart';
import 'dart:io';
import 'my_http_overrides.dart';
import 'dart:async';
// import 'package:firebase_core/firebase_core.dart';
// import 'api/firebase_api.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  
  // // Initialize Firebase before using any Firebase services
  // await Firebase.initializeApp();
  
  // // Custom initialization for Firebase notifications (if needed)
  // await FirebaseApi().initNotifications();
  
  // Set up any custom HTTP overrides (e.g., for development)
  HttpOverrides.global = MyHttpOverrides();
  
  // Run the Flutter app
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
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => NavigationBloc(),
            child: const HomeScreen(),
          ),
        ),
      );
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
