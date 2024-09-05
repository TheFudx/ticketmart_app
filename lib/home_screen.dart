// Flutter SDK
import 'package:flutter/material.dart';

// Third-Party Packages
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:ticketmart/list_screen.dart';
import 'package:translator/translator.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

// Custom Packages
import 'package:ticketmart/api_connection.dart';
import 'package:ticketmart/adventure.dart';
import 'package:ticketmart/amusement_park.dart';
import 'package:ticketmart/art.dart';
import 'package:ticketmart/comedy.dart';
import 'package:ticketmart/coming_soon.dart';
import 'package:ticketmart/kid.dart';
import 'package:ticketmart/movies_list_screen.dart';
import 'package:ticketmart/music.dart';
import 'package:ticketmart/theatre.dart';
import 'package:ticketmart/workshop.dart';
import 'package:ticketmart/notification.dart';
import 'package:ticketmart/offers.dart';
import 'package:ticketmart/profile_page.dart';
import 'package:ticketmart/search_screen.dart';
import 'package:ticketmart/side_drawer.dart';
import 'package:ticketmart/movie_detail_screen.dart';

// Specific Pages
import 'train_page.dart';
import 'flight_page.dart';
import 'bus_page.dart';


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
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
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
      _buildProfilePage(),
    ],
  );
}

Widget _buildProfilePage() {
  return const ProfilePage(
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
                          ..._predefinedCities.map(
                            (city) => DropdownMenuItem<String>(
                              value: city,
                              child: Text(city),
                            ),
                          ),
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
          width: MediaQuery.of(context).size.width * 0.99, // 90% of screen width
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildImageContainer(
                  'assets/images/movie_banner.png',
                  () {},
                  width: MediaQuery.of(context).size.width * 0.98,
                  height: screenHeight * 0.20,
                ),
                _buildImageContainer(
                  'assets/images/bus_banner.png',
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BusPage(),
                      ),
                    );
                  },
                  width: MediaQuery.of(context).size.width * 0.98,
                  height: screenHeight * 0.20,
                ),
                _buildImageContainer(
                  'assets/images/train_banner.png',
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TrainPage(),
                      ),
                    );
                  },
                  width: MediaQuery.of(context).size.width * 0.98,
                  height: screenHeight * 0.20,
                ),
                _buildImageContainer(
                  'assets/images/flight_banner.png',
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FlightPage(),
                      ),
                    );
                  },
                  width: MediaQuery.of(context).size.width * 0.98,
                  height: screenHeight * 0.20,
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
                          const SizedBox(height: 10),

                    _buildMovieSection('Recommended Movies', _newReleases),
                  _buildImageSection(
                    title: 'The Best Of Live Events',
                    images: [
                      'assets/images/amusement.webp',
                      'assets/images/workshops.webp',
                      'assets/images/kidszone.webp',
                      'assets/images/comedyshows.webp',
                      'assets/images/musicshows.webp',
                      'assets/images/theater.png',
                      'assets/images/adventure.png',
                      'assets/images/art.png',
                    ],
                    destinations: [
                      const AmusementParkPage(),
                      const WorkshopPage(),
                      const KidPage(),
                      const ComedyPage(),
                      const Music(),
                      const Theatre(),
                      const Adventure(),
                      const Art(),
                    ],
                    imageWidth: MediaQuery.of(context).size.width * 0.32,
                    imageHeight: 140,
                  ),
                  _buildImageSection(
                    title: 'Online Streaming Events',
                    images: [
                      'assets/images/online.jpg',
                      'assets/images/online.jpg',
                      'assets/images/online.jpg',
                      'assets/images/online.jpg',
                      'assets/images/streaming.jpg'
                    ],
                    destinations: List.generate(5, (_) => const ComingSoonPage()),
                    imageWidth: MediaQuery.of(context).size.width * 0.32,
                    imageHeight: 240,
                  ),
                  _buildImageSection(
                    title: 'Outdoor Events',
                    images: [
                      'assets/images/img1.avif',
                      'assets/images/2.avif',
                      'assets/images/3.avif',
                      'assets/images/4.avif',
                      'assets/images/5.avif',
                      'assets/images/6.avif',
                      'assets/images/7.avif',
                      'assets/images/8.avif',
                      'assets/images/9.avif',
                      'assets/images/10.avif'
                    ],
                    destinations: List.generate(10, (_) => const ComingSoonPage()),
                    imageWidth: MediaQuery.of(context).size.width * 0.32,
                    imageHeight: 240,
                  ),
                  _buildImageSection(
                    title: 'Laughter Therapy',
                    images: [
                      'assets/images/11.avif',
                      'assets/images/12.avif',
                      'assets/images/12.avif',
                      'assets/images/14.avif',
                      'assets/images/15.avif',
                      'assets/images/16.avif',
                      'assets/images/17.avif',
                      'assets/images/18.avif',
                      'assets/images/19.avif',
                      'assets/images/20.avif',
                    ],
                    destinations: List.generate(10, (_) => const ComingSoonPage()),
                    imageWidth: MediaQuery.of(context).size.width * 0.32,
                    imageHeight: 240,
                  ),
                  _buildImageSection(
                    title: 'Popular Events',
                    images: [
                      'assets/images/21.avif',
                      'assets/images/22.avif',
                      'assets/images/23.avif',
                      'assets/images/24.avif',
                      'assets/images/25.avif',
                      'assets/images/26.avif',
                      'assets/images/27.avif',
                      'assets/images/28.avif',
                      'assets/images/29.avif',
                      'assets/images/30.avif',
                    ],
                    destinations: List.generate(10, (_) => const ComingSoonPage()),
                    imageWidth: MediaQuery.of(context).size.width * 0.32,
                    imageHeight: 240,
                  ),
                  _buildImageSection(
                    title: 'The Latest Plays',
                    images: [
                      'assets/images/31.avif',
                      'assets/images/32.avif',
                      'assets/images/33.avif',
                      'assets/images/34.avif',
                      'assets/images/35.avif',
                      'assets/images/36.avif',
                      'assets/images/37.avif',
                      'assets/images/38.avif',
                      'assets/images/39.avif',
                      'assets/images/40.avif',
                    ],
                    destinations: List.generate(10, (_) => const ComingSoonPage()),
                    imageWidth: MediaQuery.of(context).size.width * 0.32,
                    imageHeight: 240,
                  ),
                ],
              ),
      ],
    ),
  );
}

Widget _buildImageContainer(
    String imagePath, VoidCallback onTap, {
    required double width,
    required double height,
}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      width: width,
      height: height,
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );
}

Widget _buildImageSection({
  required String title,
  required List<String> images,
  required List<Widget> destinations,
  required double imageWidth,
  required double imageHeight,
}) {
  return Column(
    children: [
      Container(
        padding: const EdgeInsets.all(16.0),
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ListScreen(
                      title: title,
                      images: images,
                      destinations: destinations,
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
      ),
      SizedBox(
        height: imageHeight,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
              images.length,
              (index) => _buildImageContainer(
                images[index],
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => destinations[index],
                    ),
                  );
                },
                width: imageWidth,
                height: imageHeight,
              ),
            ),
          ),
        ),
      ),
    ],
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
                fontSize: 11,
              ),
            ),
            // Underline placed directly below the text
            if (isSelected)
              Container(
                margin: const EdgeInsets.only(top: 4.0),
                height: 4.0, // Height of the underline
                width: 44.0, // Width of the underline
                color: Colors.blueAccent, // Color of the underline
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
