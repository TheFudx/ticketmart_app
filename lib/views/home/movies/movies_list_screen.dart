import 'package:flutter/material.dart';
import 'package:ticketmart/views/home/movies/movie_detail_screen.dart';

import '../../../model/home/movies_model.dart';

class MoviesListScreen extends StatelessWidget {
  final String title;
  final MovieModel movies;

  const MoviesListScreen({
    required this.title,
    required this.movies,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // 2 movies per row
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.7, // Adjust this to change the card aspect ratio
        ),
        itemCount: movies.movies!.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MovieDetailsScreen(
                    topOffers: 'BUY 1 GET 1 FREE',
                    movies: movies.movies![index],
                  ),
                ),
              );
            },
            child: Column(
              children: [
                Container(
                  width:
                      MediaQuery.of(context).size.width * 0.28, // Adjust size
                  height:
                      MediaQuery.of(context).size.height * 0.16, // Adjust size
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(movies.movies![index].imagePath!),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                Text(
                  movies.movies![index].title!.length > 12
                      ? movies.movies![index].title!.substring(0, 12)
                      : movies.movies![index].title!,
                  style: const TextStyle(
                      fontSize: 11, fontWeight: FontWeight.bold),
                ),
                Text(
                  movies.movies![index].releaseDate!,
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
