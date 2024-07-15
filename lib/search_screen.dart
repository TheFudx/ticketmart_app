import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ticketmart/api_connection.dart'; // Import your API connection file

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  // ignore: unused_field
  List<String> _searchResults = []; // Example list for search results
  List<String> _categoriesImages = []; // List to hold categories images

  void _search(String query) {
    // Example filtering logic
    setState(() {
      _searchResults = _mockData.where((item) => item.toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData(); // Fetch category images when screen initializes
  }

  Future<void> fetchData() async {
    try {
      final images = await ApiConnection.fetchData(''); // Replace with your API call
      setState(() {
        _categoriesImages = images.cast<String>();
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching categories images: $e');
      }
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Removes the back button
        titleSpacing: 0.0, // Ensures no space between title and leading icon
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200, // Grey fill color
                    borderRadius: BorderRadius.circular(20.0), // Curved edges
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: TextField(
                      onChanged: (value) {
                        _search(value); // Call search method on input change
                      },
                      decoration: const InputDecoration(
                        hintText: 'Search...',
                        border: InputBorder.none, // Transparent border
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade200, // Grey fill color
                borderRadius: BorderRadius.circular(20.0), // Curved edges
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
          Expanded(
            child: GridView.builder(
  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    crossAxisSpacing: 8,
    mainAxisSpacing: 8,
    childAspectRatio: 0.8, // Adjust as needed for image aspect ratio
  ),
  itemCount: _categoriesImages.length,
  itemBuilder: (context, index) {
    String imageUrl = _categoriesImages[index]; // Assuming 'imageUrl' is the key in your map
    return GridTile(
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
      ),
    );
  },
),

          ),
        ],
      ),
    );
  }

  // Example mock data
  final List<String> _mockData = [
    'Movie 1',
    'Movie 2',
    'Event 1',
    'Event 2',
    'Concert 1',
    'Concert 2',
  ];
}
