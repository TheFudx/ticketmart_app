import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ticketmart/api_connection.dart';
import 'package:ticketmart/movie_detail_screen.dart';
import 'package:ticketmart/movie_screen_grid.dart';
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
  List<String> _carouselImages = [];
  List<String> _newReleases = [];
  List<String> _trendingInTheatre = [];
  List<String> _upcoming = [];
  bool _isLoading = true;

  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _fetchMovieLists();
  }

  Future<void> _fetchMovieLists() async {
    try {
      final images = await ApiConnection.fetchCarouselImages();
      final newReleases = await ApiConnection.fetchCarouselImages();
      final trendingInTheatre = await ApiConnection.fetchCarouselImages();
      final upcoming = await ApiConnection.fetchCarouselImages();
      setState(() {
        _carouselImages = images;
        _newReleases = newReleases;
        _trendingInTheatre = trendingInTheatre;
        _upcoming = upcoming;
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
      // Handle error or display a message to the user
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
          SingleChildScrollView(
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
                          onPressed: () {
                            // Handle location button press
                          },
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
                                        child: Container(
                                          width: MediaQuery.of(context).size.width * 0.9,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: NetworkImage(_carouselImages[index]),
                                              fit: BoxFit.cover,
                                            ),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
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
          ),
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
    return cities.map((String city) {
      return DropdownMenuItem<String>(
        value: city,
        child: Text(city),
      );
    }).toList();
  }

  Widget _buildMovieSection(String title, List<String> movieImages) {
    if (movieImages.isEmpty) {
      return Container();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 2.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MovieGridScreen(
                        title: title,
                        images: movieImages,
                      ),
                    ),
                  );
                },
                child: const Text(
                  'See All >',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 270,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: movieImages.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MovieDetailsScreen(
                        movieTitle: title,
                        imageUrl: movieImages[index],
                        duration: '2h', // Add relevant details here
                        genre: 'Comedy', // Add relevant details here
                        description: 'Short film', // Add relevant details here
                        topOffers: 'Buy 1 get 1 FREE', // Add relevant details here
                        cast: const [], // Add relevant details here
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 180,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(movieImages[index]),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
