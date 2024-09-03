import 'package:flutter/material.dart';

class ListScreen extends StatelessWidget {
  final String title;
  final List<String> images;
  final List<Widget> destinations;

  const ListScreen({
    super.key,
    required this.title,
    required this.images,
    required this.destinations,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // Number of columns
          crossAxisSpacing: 10.0, // Horizontal spacing between items
          mainAxisSpacing: 10.0, // Vertical spacing between items
        ),
        padding: const EdgeInsets.all(10.0),
        itemCount: images.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => destinations[index],
                ),
              );
            },
            child: GridTile(
              footer: GridTileBar(
                title: Text('Item ${index + 1}'),
                backgroundColor: Colors.black54,
                subtitle: Text('Description ${index + 1}'),
              ),
              child: Image.asset(
                images[index],
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }
}
