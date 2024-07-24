import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ticketmart/api_connection.dart';
import 'package:ticketmart/movie_detail_screen.dart';
import 'package:ticketmart/notification.dart';
import 'package:ticketmart/offers.dart';
import 'package:ticketmart/profile_page.dart';
import 'package:ticketmart/search_screen.dart';

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

  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _fetchMovieLists();
  }

  Future<void> _fetchMovieLists() async {
    try {
      final movies = await ApiConnection.fetchCarouselImages();
      final newReleases = await ApiConnection.fetchCarouselImages();
      final trendingInTheatre = await ApiConnection.fetchCarouselImages();
      final upcoming = await ApiConnection.fetchCarouselImages();

      if (kDebugMode) {
        print('Carousel Images: $movies');
        print('New Releases: $newReleases');
        print('Trending in Theatre: $trendingInTheatre');
        print('Upcoming: $upcoming');
      }

      setState(() {
        _carouselImages = List<Map<String, dynamic>>.from(movies);
        _newReleases = List<Map<String, dynamic>>.from(movies);
        _trendingInTheatre = List<Map<String, dynamic>>.from(movies);
        _upcoming = List<Map<String, dynamic>>.from(movies);
        _isLoading = false;
      });
    } catch (e, stackTrace) {
      setState(() {
        _isLoading = false;
      });
      if (kDebugMode) {
        print('Error fetching movie lists: $e');
        print(stackTrace);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
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
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.location_on),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 8),
                  DropdownButton<String>(
                    value: _selectedCity,
                    items: _buildDropdownItems(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCity = value;
                      });
                    },
                    hint: const Text('Select City'),
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

  List<DropdownMenuItem<String>> _buildDropdownItems() {
    List<String> cities = [
      'Mumbai', 'Delhi - NCR', 'Bengaluru', 'Hyderabad', 'Ahmedabad',
      'Chandigarh', 'Pune', 'Chennai', 'Kolkata', 'Kochi'
    ];
    return cities.map((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(value),
      );
    }).toList();
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
              final id = movies[index]['id'] ?? '';
              final imagePath = movies[index]['image_path'] ?? '';
              final movieTitle = movies[index]['title'] ?? 'No Title';
              final duration = movies[index]['duration'] ?? '';
              final description = movies[index]['description'] ?? '';
              // final cast = (movies[index]['cast'] ?? '').split(',').join(', '); // Split and join cast

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MovieDetailsScreen(
                        genre: 'movies[index]',
                        movieId: id,
                        movieTitle: movieTitle,
                        imageUrl: imagePath,
                        duration: duration,
                        description: description,
                        topOffers: 'Buy 1 Get 1 Free',
                        cast: const [''],
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          imagePath,
                          height: 300,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 150,
                              width: 200,
                              color: Colors.grey,
                              child: const Icon(Icons.error),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 5),
                      SizedBox(
                        width: 100,
                        child: Text(
                          movieTitle,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12),
                        ),
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
