import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:translator/translator.dart';
import 'package:ticketmart/api_connection.dart';
import 'package:ticketmart/movie_detail_screen.dart';
import 'package:ticketmart/notification.dart';
import 'package:ticketmart/offers.dart';
import 'package:ticketmart/profile_page.dart';
import 'package:ticketmart/search_screen.dart';
import 'package:ticketmart/side_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _selectedCity;
  String? _translatedCity;
  int _selectedIndex = 0;
  List<Map<String, dynamic>> _carouselImages = [];
  List<Map<String, dynamic>> _newReleases = [];
  List<Map<String, dynamic>> _trendingInTheatre = [];
  List<Map<String, dynamic>> _upcoming = [];
  bool _isLoading = true;
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
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Optionally, handle or log the error here if needed
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
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      endDrawer: const SideDrawer(),
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
          const ProfilePage(
          theaterName: 'theatreName', 
          movieTitle: 'movie', 
          seats: [1,2,3], 
          totalSeatPrice: 100, 
          email: 'email', 
          phone: 'phone', 
          seatType: '', 
          theatreId: '', 
          movieId: '', showTime: {},),
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
        selectedItemColor: Colors.blueAccent,
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
                    onTap: _determinePosition,
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
                          value: _selectedCity ?? _translatedCity,
                          items: [
                            ..._predefinedCities
                                .map((city) => DropdownMenuItem<String>(
                                      value: city,
                                      child: Text(city),
                                    )),
                            if (_translatedCity != null)
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
                    if (_carouselImages.isNotEmpty)
                      SizedBox(
                        height: screenHeight * 0.3,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _carouselImages.length,
                          itemBuilder: (context, index) {
                            return _buildCarouselImage(context, index);
                          },
                        ),
                      ),
                    _buildMovieSection('New Releases', _newReleases),
                    _buildMovieSection(
                        'Trending in Theatre', _trendingInTheatre),
                    _buildMovieSection('Upcoming', _upcoming),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _buildCarouselImage(BuildContext context, int index) {
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MovieDetailsScreen(
              movieId: _carouselImages[index]['id'],
              movieTitle: _carouselImages[index]['title'],
              movieReleaseDate: _carouselImages[index]['release_date'],
              rating: _carouselImages[index]['rating'],
              bannerimageUrl: _carouselImages[index]['image_path'],
              imageUrl: _carouselImages[index]['banner_image_path'],
              duration: _carouselImages[index]['duration'],
              genre: _carouselImages[index]['genre'],
              description: _carouselImages[index]['description'],
              topOffers: 'BUY 1 GET 1 FREE',
              cast: _carouselImages[index]['cast'].split(','), // Split the cast string into a list
            ),
          ),
        );
      },
      child: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(_carouselImages[index]["banner_image_path"]),
                fit: BoxFit.fill,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                color: Colors.black.withOpacity(0.6),
              ),
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        _carouselImages[index]["title"],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        _carouselImages[index]["release_date"],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.black.withOpacity(0.6),
              ),
              padding: const EdgeInsets.all(5.0),
              child: Row(
                children: [
                  const Icon(
                    Icons.star,
                    color: Colors.yellow,
                    size: 14,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _carouselImages[index]["rating"].toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

  Widget _buildMovieSection(String title, List<Map<String, dynamic>> movies) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(
              height: MediaQuery.of(context).size.height *
                  0.26,            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: movies.length,
              itemBuilder: (context, index) {
                return _buildMovieCard(context, movies, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMovieCard(
      BuildContext context, List<Map<String, dynamic>> movies, int index) {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MovieDetailsScreen(
                movieId: movies[index]['id'],
                movieTitle: movies[index]['title'],
                movieReleaseDate: movies[index]['release_date'],
                rating: movies[index]['rating'],
                bannerimageUrl: _carouselImages[index]['image_path'],
                imageUrl: movies[index]['banner_image_path'],
                duration: movies[index]['duration'],
                genre: movies[index]['genre'],
                description: movies[index]['description'],
                topOffers: 'BUY 1 GET 1 FREE',
                cast: movies[index]['cast']
                    .split(','), // Split the cast string into a list
              ),
            ),
          );
        },
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width *
                  0.3, // 30% of the screen width
              height: MediaQuery.of(context).size.height *
                  0.22, // 40% of the screen height
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(movies[index]['image_path']),
                  fit: BoxFit.fitHeight,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            Text(
              movies[index]['title'].length > 12
                  ? '${movies[index]['title'].substring(0, 12)}...'
                  : movies[index]['title'],
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            ),
            Text(
              movies[index]['release_date'],
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    _pageController.jumpToPage(index);
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
