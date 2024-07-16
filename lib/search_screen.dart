import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
// Example list for search results
// List to hold categories images

  void _search(String query) {
    // Example filtering logic
    setState(() {
    });
  }

  @override
  void initState() {
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Removes the back button
        titleSpacing: 0.0, // Ensures no space between title and leading icon
        title: Row(
          children: [
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
      body: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Explore Categories',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Example mock data
}
