import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:ticketmart/amusement_park.dart';
import 'package:ticketmart/comedy.dart';
import 'package:ticketmart/coming_soon.dart';
import 'package:ticketmart/kid.dart';
import 'package:ticketmart/movies_list_screen.dart';
import 'package:ticketmart/music.dart';
import 'package:ticketmart/workshop.dart';
import 'package:translator/translator.dart';
import 'package:ticketmart/api_connection.dart';
import 'package:ticketmart/movie_detail_screen.dart';
import 'package:ticketmart/notification.dart';
import 'package:ticketmart/offers.dart';
import 'package:ticketmart/profile_page.dart';
import 'package:ticketmart/search_screen.dart';
import 'package:ticketmart/side_drawer.dart';
import 'train_page.dart';
import 'flight_page.dart';
import 'bus_page.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

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
  // List<Map<String, dynamic>> _trendingInTheatre = [];
  // List<Map<String, dynamic>> _upcoming = [];
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
        // _trendingInTheatre = List<Map<String, dynamic>>.from(movies);
        // _upcoming = List<Map<String, dynamic>>.from(movies);
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
            seats: [],
            totalSeatPrice: 100,
            email: 'email',
            phone: 'phone',
            seatType: '',
            theatreId: '',
            movieId: '',
            showTime: {},
            totalPrice: 1,
          ),
        ],
      ),
      bottomNavigationBar: SalomonBottomBar(
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
            title: const Text("Home"),
            selectedColor: Colors.purple,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.search),
            title: const Text("Search"),
            selectedColor: Colors.orange,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.local_offer),
            title: const Text("Offers"),
            selectedColor: Colors.green,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.person),
            title: const Text("Profile"),
            selectedColor: Colors.teal,
          ),
        ],
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
          Container(
            padding: const EdgeInsets.symmetric(vertical: 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCategoryIcon(
                  icon: Icons.movie,
                  label: 'Movies',
                  isSelected: _selectedIndex == 0,
                  onTap: () {},
                ),
                _buildCategoryIcon(
                  icon: Icons.directions_bus,
                  label: 'Bus',
                  isSelected: _selectedIndex == 3,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BusPage(),
                      ),
                    );
                  },
                ),
                _buildCategoryIcon(
                  icon: Icons.train,
                  label: 'Train',
                  isSelected: _selectedIndex == 1,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TrainPage(),
                      ),
                    );
                  },
                ),
                _buildCategoryIcon(
                  icon: Icons.flight,
                  label: 'Flight',
                  isSelected: _selectedIndex == 2,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FlightPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
  height: screenHeight * 0.20, // Adjust height as needed
  width: 422,
  child: SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: [
        _buildImageContainer(
          context,
          'assets/images/movie_banner.png',
          () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) =>  
// const MoviesListScreen(
//                         title: "title",
//                         movies: [],
//                       ),              
//               ),
//             );
          },
        ),
        _buildImageContainer(
          context,
          'assets/images/bus_banner.png',
          () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const BusPage()),
            );
          },
        ),
        _buildImageContainer(
          context,
          'assets/images/train_banner.png',
          () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TrainPage()),
            );
          },
        ),
        _buildImageContainer(
          context,
          'assets/images/flight_banner.png',
          () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FlightPage()),
            );
          },
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
                      _buildMovieSection('Recommended Movies', _newReleases),
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'The Best Of Live Events',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    SizedBox(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildImageLiveContainer(
                                'assets/images/amusement.webp',
                                const AmusementParkPage()),
                            _buildImageLiveContainer(
                                'assets/images/workshops.webp',
                                const WorkshopPage()),
                            _buildImageLiveContainer(
                                'assets/images/kidszone.webp', const KidPage()),
                            _buildImageLiveContainer(
                                'assets/images/comedyshows.webp',
                                const ComedyPage()),
                            _buildImageLiveContainer(
                                'assets/images/musicshows.webp', const Music()),
                            _buildImageLiveContainer(
                                'assets/images/theater.png',
                                const ComingSoonPage()),
                            _buildImageLiveContainer(
                                'assets/images/adventure.png',
                                const ComingSoonPage()),
                            _buildImageLiveContainer('assets/images/art.png',
                                const ComingSoonPage()),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'Online Streaming Events',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    SizedBox(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildImageOnlineContainer(
                                'assets/images/online.jpg'),
                            _buildImageOnlineContainer(
                                'assets/images/online.jpg'),
                            _buildImageOnlineContainer(
                                'assets/images/online.jpg'),
                            _buildImageOnlineContainer(
                                'assets/images/online.jpg'),
                            _buildImageOnlineContainer(
                                'assets/images/streaming.jpg')
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'Outdoor Events',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    SizedBox(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildOutdoorContainer('assets/images/img1.avif'),
                            _buildOutdoorContainer('assets/images/2.avif'),
                            _buildOutdoorContainer('assets/images/3.avif'),
                            _buildOutdoorContainer('assets/images/4.avif'),
                            _buildOutdoorContainer('assets/images/5.avif'),
                            _buildOutdoorContainer('assets/images/6.avif'),
                            _buildOutdoorContainer('assets/images/7.avif'),
                            _buildOutdoorContainer('assets/images/8.avif'),
                            _buildOutdoorContainer('assets/images/9.avif'),
                            _buildOutdoorContainer('assets/images/10.avif')
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(15.0),
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'Laughter Therapy',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    SizedBox(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildLaughterContainer('assets/images/11.avif'),
                            _buildLaughterContainer('assets/images/12.avif'),
                            _buildLaughterContainer('assets/images/12.avif'),
                            _buildLaughterContainer('assets/images/14.avif'),
                            _buildLaughterContainer('assets/images/15.avif'),
                            _buildLaughterContainer('assets/images/16.avif'),
                            _buildLaughterContainer('assets/images/17.avif'),
                            _buildLaughterContainer('assets/images/18.avif'),
                            _buildLaughterContainer('assets/images/19.avif'),
                            _buildLaughterContainer('assets/images/20.avif'),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'Popular Events',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    SizedBox(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildPopularEventsContainer(
                                'assets/images/21.avif'),
                            _buildPopularEventsContainer(
                                'assets/images/22.avif'),
                            _buildPopularEventsContainer(
                                'assets/images/23.avif'),
                            _buildPopularEventsContainer(
                                'assets/images/24.avif'),
                            _buildPopularEventsContainer(
                                'assets/images/25.avif'),
                            _buildPopularEventsContainer(
                                'assets/images/26.avif'),
                            _buildPopularEventsContainer(
                                'assets/images/27.avif'),
                            _buildPopularEventsContainer(
                                'assets/images/28.avif'),
                            _buildPopularEventsContainer(
                                'assets/images/29.avif'),
                            _buildPopularEventsContainer(
                                'assets/images/30.avif')
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'The Latest Plays',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    SizedBox(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildLatestPlaysContainer('assets/images/31.avif'),
                            _buildLatestPlaysContainer('assets/images/32.avif'),
                            _buildLatestPlaysContainer('assets/images/33.avif'),
                            _buildLatestPlaysContainer('assets/images/34.avif'),
                            _buildLatestPlaysContainer('assets/images/35.avif'),
                            _buildLatestPlaysContainer('assets/images/36.avif'),
                            _buildLatestPlaysContainer('assets/images/37.avif'),
                            _buildLatestPlaysContainer('assets/images/38.avif'),
                            _buildLatestPlaysContainer('assets/images/39.avif'),
                            _buildLatestPlaysContainer('assets/images/40.avif')
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }

Widget _buildImageContainer(BuildContext context, String imagePath, VoidCallback onTap) {
  return InkWell(
    onTap: onTap, // Handle tap for navigation
    child: Container(
      width: MediaQuery.of(context).size.width * 0.97, // Adjust width as a fraction of screen width
      height: MediaQuery.of(context).size.height * 0.2, // Adjust height as needed
      margin: const EdgeInsets.symmetric(horizontal: 5.0), // Add margin for spacing
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(5), // Optional: Add border radius if needed
      ),
    ),
  );
}


  Widget _buildImageLiveContainer(String imagePath, Widget destinationPage) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destinationPage),
        );
      },
      child: Container(
        width:
            MediaQuery.of(context).size.width * 0.32, // Adjust width as needed
        height: 140, // Adjust height as needed
        margin: const EdgeInsets.symmetric(
            horizontal: 5.0), // Add margin for spacing
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
          borderRadius:
              BorderRadius.circular(8), // Optional: Add border radius if needed
        ),
      ),
    );
  }

  Widget _buildImageOnlineContainer(String imagePath) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ComingSoonPage()),
        );
      },
      child: Container(
        width:
            MediaQuery.of(context).size.width * 0.32, // Adjust width as needed
        height: 240, // Adjust height as needed
        margin: const EdgeInsets.symmetric(
            horizontal: 5.0), // Add margin for spacing
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
          borderRadius:
              BorderRadius.circular(8), // Optional: Add border radius if needed
        ),
      ),
    );
  }

  Widget _buildOutdoorContainer(String imagePath) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ComingSoonPage()),
        );
      },
      child: Container(
        width:
            MediaQuery.of(context).size.width * 0.32, // Adjust width as needed
        height: 240, // Adjust height as needed
        margin: const EdgeInsets.symmetric(
            horizontal: 5.0), // Add margin for spacing
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
          borderRadius:
              BorderRadius.circular(8), // Optional: Add border radius if needed
        ),
      ),
    );
  }

  Widget _buildLaughterContainer(String imagePath) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ComingSoonPage()),
        );
      },
      child: Container(
        width:
            MediaQuery.of(context).size.width * 0.32, // Adjust width as needed
        height: 240, // Adjust height as needed
        margin: const EdgeInsets.symmetric(
            horizontal: 5.0), // Add margin for spacing
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
          borderRadius:
              BorderRadius.circular(8), // Optional: Add border radius if needed
        ),
      ),
    );
  }

  Widget _buildPopularEventsContainer(String imagePath) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ComingSoonPage()),
        );
      },
      child: Container(
        width:
            MediaQuery.of(context).size.width * 0.32, // Adjust width as needed
        height: 240, // Adjust height as needed
        margin: const EdgeInsets.symmetric(
            horizontal: 5.0), // Add margin for spacing
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
          borderRadius:
              BorderRadius.circular(8), // Optional: Add border radius if needed
        ),
      ),
    );
  }

  Widget _buildLatestPlaysContainer(String imagePath) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ComingSoonPage()),
        );
      },
      child: Container(
        width:
            MediaQuery.of(context).size.width * 0.32, // Adjust width as needed
        height: 240, // Adjust height as needed
        margin: const EdgeInsets.symmetric(
            horizontal: 5.0), // Add margin for spacing
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
          borderRadius:
              BorderRadius.circular(8), // Optional: Add border radius if needed
        ),
      ),
    );
  }

  Widget _buildCategoryIcon({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(
            icon,
            color: isSelected ? Colors.blueAccent : Colors.grey,
            size: 35,
          ),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.blueAccent : Colors.black,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMovieSection(String title, List<Map<String, dynamic>> movies) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MoviesListScreen(
                        title: title,
                        movies: movies,
                      ),
                    ),
                  );
                },
                child: const Row(
                  children: [
                    Text(
                      "See All",
                      style: TextStyle(fontSize: 14, color: Colors.blue),
                    ),
                    Icon(Icons.chevron_right_rounded, color: Colors.blue),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.26,
            child: ListView.builder(
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
                cast: movies[index]['cast'].split(','),
                // Split the cast string into a list
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

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
