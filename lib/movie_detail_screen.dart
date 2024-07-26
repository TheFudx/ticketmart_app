import 'package:flutter/material.dart';
import 'package:share/share.dart'; // Import the share package
import 'package:ticketmart/theatres_list_screen.dart';

class MovieDetailsScreen extends StatelessWidget {
  final String movieId;
  final String movieTitle;
  final String movieReleaseDate;
  final String imageUrl; // Assuming you pass the image URL for the movie
  final String duration;
  final String genre;
  final String description;
  final String topOffers;
  final List<String> cast;

  const MovieDetailsScreen({
    super.key,
    required this.movieId,
    required this.movieTitle,
    required this.imageUrl,
    required this.duration,
    required this.genre,
    required this.description,
    required this.topOffers,
    required this.cast,
    required this.movieReleaseDate,
  });

  @override
  Widget build(BuildContext context) {
    final double imageHeight = MediaQuery.of(context).size.height * 0.2;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min, // Ensure the row only takes up as much space as needed
          children: [
            Text(
              movieTitle,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.black),
            onPressed: () => _shareMovie(context),
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _buildMovieImage(imageHeight),
                const SizedBox(height: 20.0),
                _buildMovieInfoRow(),
                const SizedBox(height: 10.0),
                _buildDescription(description),
                const SizedBox(height: 10.0),
                _buildSectionTitle('Top Offers for You'),
                _buildTopOffers(topOffers),
                const SizedBox(height: 10.0),
                _buildDetailRow('Cast', cast.join(', ')),
                const SizedBox(height: 80.0), // Extra space for the button
              ],
            ),
          ),
          Positioned(
            bottom: 20.0,
            left: 20.0,
            right: 20.0,
            child: _buildCheckTheatresButton(context),
          ),
        ],
      ),
    );
  }

  Widget _buildMovieImage(double height) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5.0),
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildMovieInfoRow() {
    return Row(
      children: <Widget>[
        Text(
          duration,
          style: const TextStyle(fontSize: 14.0, color: Colors.grey),
        ),
        _buildSeparator(),
        Text(
          genre,
          style: const TextStyle(fontSize: 14.0, color: Colors.grey),
        ),
        _buildSeparator(),
        Text(
          movieReleaseDate,
          style: const TextStyle(fontSize: 14.0, color: Colors.grey),
        ),
        _buildSeparator(),
        Text(
          movieId,
          style: const TextStyle(fontSize: 14.0, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildSeparator() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Text(
        '•',
        style: TextStyle(fontSize: 20.0, color: Colors.black, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  Widget _buildDescription(String description) {
    return Text(
      description,
      style: const TextStyle(fontSize: 16.0, color: Colors.black),
    );
  }

  Widget _buildTopOffers(String offers) {
    return Text(
      offers,
      style: const TextStyle(fontSize: 16.0, color: Colors.grey),
    );
  }

  Widget _buildDetailRow(String title, String detail) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
          ),
          Expanded(
            child: Text(
              detail,
              style: const TextStyle(fontSize: 16.0),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckTheatresButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TheatersListScreen(
              imageUrl: imageUrl,
              movieTitle: movieTitle,
              movieId: movieId,
            ),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.redAccent,
        padding: const EdgeInsets.symmetric(vertical: 15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      child: const Text(
        'Check Theatres',
        style: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _shareMovie(BuildContext context) {
    final RenderBox box = context.findRenderObject() as RenderBox;
    Share.share(
      'Check out $movieTitle! $imageUrl',
      subject: movieTitle,
      sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,
    );
  }
}
