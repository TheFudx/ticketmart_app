import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketmart/movie_screen_grid.dart';
import 'package:ticketmart/notification.dart';
import 'package:ticketmart/offers.dart';
import 'package:ticketmart/profile_page.dart';
import 'package:ticketmart/search_screen.dart';
import 'api_connection.dart';
// import 'bloc/navigation_bloc.dart';
// import 'bloc/navigation_event.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _selectedCity; // Variable to hold selected city
  int _selectedIndex = 0; // Track selected index for bottom nav bar
  List<String> _carouselImages = []; // List to hold image URLs
  List<String> _newReleases = []; // List to hold new releases
  List<String> _trendingInTheatre = []; // List to hold trending in theatre
  List<String> _upcoming = []; // List to hold upcoming movies
  bool _isLoading = true; // Flag to track loading state

  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _fetchMovieLists(); // Fetch movie lists when the screen initializes
  }

  Future<void> _fetchMovieLists() async {
    try {
      final images = await ApiConnection.fetchCarouselImages();
      final newReleases = await ApiConnection
          .fetchCarouselImages(); // Assuming separate methods for different lists
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
      }
      if (kDebugMode) {
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
                  padding: const EdgeInsets.only(top: 40.0), // Add top padding here
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
                              _selectedCity = value; // Update selected city
                            });
                            // Handle dropdown item selection if needed
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
                                    builder: (context) =>
                                        const NotificationScreen()));
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
                                  height: screenHeight *
                                      0.3, // 30% of the screen height
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: _carouselImages.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          width: MediaQuery.of(context).size.width *
                                              0.9,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                  _carouselImages[index]),
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
                          _buildMovieSection(
                              'Trending in Theatre', _trendingInTheatre),
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
    return [
      const DropdownMenuItem(
        value: 'Mumbai',
        child: Text('Mumbai'),
      ),
      const DropdownMenuItem(
        value: 'Delhi - NCR',
        child: Text('Delhi - NCR'),
      ),
      const DropdownMenuItem(
        value: 'Bengaluru',
        child: Text('Bengaluru'),
      ),
      const DropdownMenuItem(
        value: 'Hyderabad',
        child: Text('Hyderabad'),
      ),
      const DropdownMenuItem(
        value: 'Ahmedabad',
        child: Text('Ahmedabad'),
      ),
      const DropdownMenuItem(
        value: 'Chandigarh',
        child: Text('Chandigarh'),
      ),
      const DropdownMenuItem(
        value: 'Pune',
        child: Text('Pune'),
      ),
      const DropdownMenuItem(
        value: 'Chennai',
        child: Text('Chennai'),
      ),
      const DropdownMenuItem(
        value: 'Kolkata',
        child: Text('Kolkata'),
      ),
      const DropdownMenuItem(
        value: 'Kochi',
        child: Text('Kochi'),
      ),
    ];
  }

  Widget _buildMovieSection(String title, List<String> movieImages) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
              16.0, 16.0, 16.0, 2.0), // Adjusted padding values
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
                      builder: (context) =>
                          MovieGridScreen(title: title, images: movieImages),
                    ),
                  );
                },
                child: const Text(
                  'See All',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 250, // Adjust the height as needed
          child: ListView.builder(
            padding: const EdgeInsets.only(
                left: 8.0), // Adjusted left padding for images
            scrollDirection: Axis.horizontal,
            itemCount: movieImages.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(
                    right: 8.0), // Adjusted right padding for images
                child: Stack(
                  children: [
                    Container(
                      width: 175, // Adjust the width as needed
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(movieImages[index]),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '4.4',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Icon(
                                Icons.star,
                                color: Colors.yellow,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
