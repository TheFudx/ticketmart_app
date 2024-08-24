import 'package:flutter/material.dart';
import 'package:ticketmart/movie_detail_screen.dart';


class MoviesListScreen extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> movies;

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
        itemCount: movies.length,
        itemBuilder: (context, index) {
          return _buildMovieCard(context, movies, index);
        },
      ),
    );
  }

  Widget _buildMovieCard(
      BuildContext context, List<Map<String, dynamic>> movies, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MovieDetailsScreen(
              movieId: movies[index]['id'],
              movieTitle: movies[index]['title'],
              movieReleaseDate: movies[index]['release_date'],
              rating: movies[index]['rating'],
              bannerimageUrl: movies[index]['image_path'],
              imageUrl: movies[index]['banner_image_path'],
              duration: movies[index]['duration'],
              genre: movies[index]['genre'],
              description: movies[index]['description'],
              topOffers: 'BUY 1 GET 1 FREE',
              cast: movies[index]['cast'].split(','), // Split the cast string into a list
            ),
          ),
        );
      },
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.28, // Adjust size
            height: MediaQuery.of(context).size.height * 0.16, // Adjust size
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(movies[index]['image_path']),
                fit: BoxFit.cover,
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
    );
  }
}
