// Flutter SDK

import 'package:flutter/material.dart';

// Third-Party Packages
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import 'package:translator/translator.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import 'package:ticketmart/notification.dart';
import 'package:ticketmart/views/offers/offers.dart';
import 'package:ticketmart/views/search/search_screen.dart';
import 'package:ticketmart/views/Login/side_drawer.dart';

import '../../../model/home/movies_model.dart';
import '../../../utils/app_assets.dart';
import '../../../utils/app_string.dart';
import '../../profile/user_profile.dart';
import 'widget/home_widget.dart';

class HomeScreen extends StatefulWidget {
  final int userId;
  const HomeScreen(this.userId, {super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  String? _selectedCity;
  String? _translatedCity;
  int _selectedIndex = 0;
  MovieModel? newReleases;

  bool _isLocationLoading = false;

  final List<String> _predefinedCities = [
    'Mumbai',
    'Delhi',
    'Jaipur',
    'Bengaluru',
    'Kolkata',
    'Pune',
    'Thane',
    'Chennai',
    'Hyderabad',
    'Ahmedabad',
    'Kochi'
  ];

  final PageController _pageController = PageController();
  final GoogleTranslator _translator =
      GoogleTranslator(); // Translator instance

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    setState(() => _isLocationLoading = true);
    try {
      if (!await Geolocator.isLocationServiceEnabled()) return;
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever ||
          (permission != LocationPermission.whileInUse &&
              permission != LocationPermission.always)) {
        return;
      }
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      await getAddressFromLatLng(position);
    } catch (e) {
      print('Error determining position: $e');
    } finally {
      setState(() => _isLocationLoading = false);
    }
  }

  Future<void> getAddressFromLatLng(Position position) async {
    try {
      final placeMarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placeMarks.isNotEmpty) {
        final place = placeMarks.first;
        final city = place.locality;
        // Translate city name
        final translated = await _translator.translate(city ?? '', to: 'en');
        setState(() {
          _translatedCity = translated.text; // Store the translated text
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      endDrawer: const SideDrawer(),
      body: _buildPageView(screenHeight),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildPageView(double screenHeight) {
    return PageView(
      controller: _pageController,
      onPageChanged: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      children: <Widget>[
        _buildHomePage(screenHeight),
        const SearchScreen(),
        const OffersScreen(),
        const UserProfile(),
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    return SalomonBottomBar(
      currentIndex: _selectedIndex,
      onTap: (index) {
        _pageController.jumpToPage(index);
        setState(() {
          _selectedIndex = index;
        });
      },
      items: [
        SalomonBottomBarItem(
          icon: const Icon(Icons.home),
          title: const Text(AppString.homeTxt),
          selectedColor: Colors.purple,
        ),
        SalomonBottomBarItem(
          icon: const Icon(Icons.search),
          title: const Text(AppString.searchTxt),
          selectedColor: Colors.orange,
        ),
        SalomonBottomBarItem(
          icon: const Icon(Icons.local_offer),
          title: const Text(AppString.offersTxt),
          selectedColor: Colors.green,
        ),
        SalomonBottomBarItem(
          icon: const Icon(Icons.person),
          title: const Text(AppString.profileTxt),
          selectedColor: Colors.teal,
        ),
      ],
    );
  }

  Widget _buildHomePage(double screenHeight) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 40.0),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: _determinePosition,
                    child: Image.asset(
                      AppAssets.logo,
                      width: 60,
                      height: 60,
                    ),
                  ),
                  const SizedBox(width: 8),
                  _isLocationLoading
                      ? const CircularProgressIndicator()
                      : DropdownButton<String>(
                          value: _selectedCity ?? _translatedCity,
                          items: [
                            ..._predefinedCities.map(
                              (city) => DropdownMenuItem<String>(
                                value: city,
                                child: Text(city),
                              ),
                            ),
                            if (_translatedCity != null &&
                                !_predefinedCities.contains(_translatedCity))
                              DropdownMenuItem<String>(
                                value: _translatedCity,
                                child: Text(_translatedCity!),
                              ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedCity = value;
                              _translatedCity = value;
                            });
                          },
                          hint: const Text('Choose Location'),
                        ),
                  const Spacer(),

                  // Notification Button
                  IconButton(
                    icon: const Icon(Icons.notifications),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NotificationScreen(),
                        ),
                      );
                    },
                  ),

                  // Drawer Button
                  Builder(
                    builder: (context) => IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () {
                        Scaffold.of(context).openEndDrawer();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          buildImageContainer(
            AppAssets.movieBanner,
            width: MediaQuery.of(context).size.width * 0.98,
            height: screenHeight * 0.20,
          ),
        ],
      ),
    );
  }
}
