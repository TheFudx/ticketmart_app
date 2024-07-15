import 'package:flutter/material.dart';

class MovieGridScreen extends StatelessWidget {
  final List<String> images;
  final String title;

  const MovieGridScreen({
    super.key,
    required this.images,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title), // Display the dynamic title in the AppBar
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          child: GridView.builder(
            shrinkWrap: true, // Ensure that the GridView scrolls inside the SingleChildScrollView
            physics: const NeverScrollableScrollPhysics(), // Disable GridView scrolling
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // Number of columns in the grid
              crossAxisSpacing: 12.0,
              mainAxisSpacing: 12.0,
            ),
            itemCount: images.length,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(images[index]),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
