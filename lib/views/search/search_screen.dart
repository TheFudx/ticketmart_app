import 'package:flutter/material.dart';
import 'package:ticketmart/views/home/drawer/home_screen.dart';
import 'package:ticketmart/views/offers/offers.dart';
import 'package:ticketmart/api_connection.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  Future<List<Map<String, dynamic>>>? _theatresFuture;
  List<Map<String, dynamic>>? _allTheatres; // Holds all theatres data
  List<Map<String, dynamic>>? _filteredTheatres; // Holds filtered theatres data

  @override
  void initState() {
    super.initState();
    _theatresFuture = ApiConnection.fetchTheatres();
    _theatresFuture!.then((data) {
      setState(() {
        _allTheatres = data;
        _filteredTheatres = data; // Initialize filtered list with all data
      });
    });
  }

  void _search(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredTheatres = _allTheatres; // Reset to all data if query is empty
      });
    } else {
      setState(() {
        _filteredTheatres = _allTheatres!
            .where((theatre) =>
                theatre['title'].toLowerCase().contains(query.toLowerCase()))
            .toList(); // Filter based on query
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 0.0,
        title: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: TextField(
                      onChanged: (value) {
                        _search(value);
                      },
                      decoration: const InputDecoration(
                        hintText: 'Search Movies, Events & More.. ',
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: () {
                  // Handle filter icon press
                }, 
              ),
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Explore Categories',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 25.0,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              children: [
                _buildCategoryItem(context, 'Movies'),
                _buildCategoryItem(context, 'Events'),
                _buildCategoryItem(context, 'Plays'),
                _buildCategoryItem(context, 'Sports'),
                _buildCategoryItem(context, 'Offers'),
                _buildCategoryItem(context, 'Others'),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            color: Colors.grey.shade300,
            padding: const EdgeInsets.all(8.0),
            width: double.infinity,
            child: const Row(
              children: [
                Icon(
                  Icons.trending_up,
                  color: Colors.blue,
                  size: 24.0,
                ),
                SizedBox(width: 8.0),
                Text(
                  'Trending Searches',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _filteredTheatres == null
                ? const Center(child: CircularProgressIndicator())
                : _filteredTheatres!.isEmpty
                    ? const Center(child: Text('No movies available'))
                    : ListView.separated(
                        padding:
                            EdgeInsets.zero, // Remove padding from the ListView
                        itemCount: _filteredTheatres!.length,
                        separatorBuilder: (context, index) => const Divider(
                          height: 0.0, // Reduce the height of the divider
                          thickness: 0.5, // Set the thickness of the divider
                        ),
                        itemBuilder: (context, index) {
                          final theatre = _filteredTheatres![index];
                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 0.0, horizontal: 16.0),
                            title: Text(
                              theatre['title'],
                              style: const TextStyle(fontSize: 14),
                            ),
                            trailing: const Icon(
                              Icons.movie_creation,
                              color: Colors.blue,
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(BuildContext context, String title) {
    return GestureDetector(
      onTap: () {
        if (title == 'Movies') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        } else if (title == 'Offers') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const OffersScreen()),
          );
        }
        // Handle other categories if needed
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(
            color: Colors.black.withOpacity(0.4),
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.blue,
            ),
          ),
        ),
      ),
    );
  }
}
