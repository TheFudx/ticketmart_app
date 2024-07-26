import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ticketmart/api_connection.dart';
import 'package:ticketmart/movie_detail_screen.dart';
import 'package:ticketmart/notification.dart';
import 'package:ticketmart/offers.dart';
import 'package:ticketmart/profile_page.dart';
import 'package:ticketmart/search_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'side_drawer.dart'; // Add this import

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _selectedCity;
  int _selectedIndex = 0;
  List<Map<String, dynamic>> _carouselImages = [];
  List<Map<String, dynamic>> _newReleases = [];
  List<Map<String, dynamic>> _trendingInTheatre = [];
  List<Map<String, dynamic>> _upcoming = [];
  bool _isLoading = true;
  bool _isLocationLoading = false;

  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _fetchMovieLists();
    _determinePosition();
  }

  Future<void> _fetchMovieLists() async {
    try {
      final movies = await ApiConnection.fetchCarouselImages();

      setState(() {
        _carouselImages = List<Map<String, dynamic>>.from(movies);
        _newReleases = List<Map<String, dynamic>>.from(movies);
        _trendingInTheatre = List<Map<String, dynamic>>.from(movies);
        _upcoming = List<Map<String, dynamic>>.from(movies);
        _isLoading = false;
      });
    // ignore: unused_catch_stack
    } catch (e, stackTrace) {
      setState(() {
        _isLoading = false;
      });
      // Optionally, you can handle or log the error here if needed
    }
  }

  Future<void> _determinePosition() async {
    setState(() {
      _isLocationLoading = true;
    });

    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _isLocationLoading = false;
      });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _isLocationLoading = false;
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _isLocationLoading = false;
      });
      return;
    }

    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    await _getAddressFromLatLng(position);

    setState(() {
      _isLocationLoading = false;
    });
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    try {
      final placeMarks = await placemarkFromCoordinates(
          position.latitude, position.longitude);
      if (placeMarks.isNotEmpty) {
        final place = placeMarks.first;
        setState(() {
          _selectedCity = place.locality;
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      endDrawer: const SideDrawer(), // Include the Drawer widget here
      body: PageView(
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
          const ProfilePage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_offer),
            label: 'Offers',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.redAccent,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),
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
                  onTap: () {
                    _determinePosition();
                  },
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 60,
                    height: 60,
                  ),
                ),
                const SizedBox(width: 8),
                _isLocationLoading
                    ? const CircularProgressIndicator()
                    : DropdownButton<String>(
                        value: _selectedCity,
                        items: _selectedCity != null
                            ? [
                                DropdownMenuItem<String>(
                                  value: _selectedCity,
                                  child: Text(_selectedCity!),
                                ),
                              ]
                            : [],
                        onChanged: (value) {
                          setState(() {
                            _selectedCity = value;
                          });
                        },
                        hint: const Text('Choose Location'),
                      ),
                const Spacer(),
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
        _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  _carouselImages.isNotEmpty
                      ? SizedBox(
                          height: screenHeight * 0.3,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _carouselImages.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Stack(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width * 0.9,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage(_carouselImages[index]["image_path"]),
                                          fit: BoxFit.cover,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    Positioned(
                                      top: 10,
                                      right: 10,
                                      child: Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          color: Colors.black54,
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        child: Row(
                                          children: [
                                            Text(
                                              _carouselImages[index]["rating"].toString(),
                                              style: const TextStyle(color: Colors.white),
                                            ),
                                            const Icon(
                                              Icons.star,
                                              color: Colors.yellow,
                                              size: 16,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        )
                      : Container(),
                  _buildMovieSection('New Releases', _newReleases),
                  _buildMovieSection('Trending in Theatre', _trendingInTheatre),
                  _buildMovieSection('Upcoming', _upcoming),
                ],
              ),
      ],
    ),
  );
}

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  Widget _buildMovieSection(String title, List<Map<String, dynamic>> movies) {
    if (movies.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 340,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final movie = movies[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                         builder: (context) => MovieDetailsScreen(
                          movieId: movies[index]['id'],
                          movieTitle: movies[index]['title'],
                          movieReleaseDate: movies[index]['release_date'],
                          imageUrl: movies[index]['image_path'], 
                          duration: movies[index]['duration'], 
                          genre: movies[index]['genre'], 
                          description: movies[index]['description'], 
                          topOffers: 'BUY 1 GET 1 FREE', 
                          cast: const [],),
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 160,
                          height: 240,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(movie["image_path"]),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: 160,
                          child: Text(
                            movie["title"],
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          
                        ),
                         const SizedBox(height: 4),
                        Text(
                          'Release: ${movies[index]["release_date"]}',
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.yellow, size: 16),
                            Text(
                              movies[index]["rating"].toString(),
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
