import 'package:flutter/material.dart';
import 'package:share/share.dart'; // Import the share package
import 'package:ticketmart/theatres_list_screen.dart';

class MovieDetailsScreen extends StatelessWidget {
  final String movieId;
  final String movieTitle;
  final String movieReleaseDate;
  final String rating;
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
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    final double imageHeight = MediaQuery.of(context).size.height * 0.2;
    final double imageWidth =
        MediaQuery.of(context).size.width - 40; // Adjust width as needed

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          mainAxisSize: MainAxisSize
              .min, // Ensure the row only takes up as much space as needed
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
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _buildMovieImage(imageWidth, imageHeight),
                  const SizedBox(height: 20.0),
                  _buildMovieInfoRow(),
                  const SizedBox(height: 10.0),
                  _buildDescription(description),
                  const SizedBox(height: 20.0),
                  _buildSectionTitle('Top Offers for You'),
                  const SizedBox(height: 10),
                  _buildOffersSection(),
                  const SizedBox(height: 20.0),
                  _buildSectionTitle('Star Cast'),
                  const SizedBox(height: 5),
                  _buildStarCast(cast),
                  const SizedBox(height: 80.0), // Extra space for the button
                ],
              ),
            ),
          ),
          _buildCheckTheatresButton(context),
        ],
      ),
    );
  }

  Widget _buildMovieImage(double width, double height) {
    return Stack(
      children: [
        Container(
          width: width,
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
        ),
        Positioned(
          bottom: 10,
          left: 10,
          child: Container(
            padding: const EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.star,
                  color: Colors.yellow,
                  size: 16.0,
                ),
                const SizedBox(width: 4.0),
                Text(
                  rating,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMovieInfoRow() {
    return Row(
      children: <Widget>[
        _buildInfoContainer(duration),
        _buildSeparator(),
        _buildInfoContainer(genre),
        _buildSeparator(),
        _buildInfoContainer(movieReleaseDate),
        _buildSeparator(),
        _buildInfoContainer(movieId),
      ],
    );
  }

  Widget _buildInfoContainer(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.grey[300], // Light grey background color
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14.0, color: Colors.black),
      ),
    );
  }

  Widget _buildSeparator() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Text(
        '•',
        style: TextStyle(
            fontSize: 20.0, color: Colors.black, fontWeight: FontWeight.bold),
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
      style: const TextStyle(fontSize: 14.0, color: Colors.black),
    );
  }

  Widget _buildOffersSection() {
    return SizedBox(
      height: 60.0, // Adjust height as needed
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          _buildOfferCard('HDFC: 10% off on movie tickets'),
          const SizedBox(width: 10.0),
          _buildOfferCard('Kotak: 15% off on first purchase'),
          const SizedBox(width: 10.0),
          _buildOfferCard('Axis: 5% cashback on movie tickets'),
        ],
      ),
    );
  }

  Widget _buildOfferCard(String offer) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
      ),
      child: Container(
        width: 300.0, // Adjust width as needed
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            offer,
            style: const TextStyle(fontSize: 14.0, color: Colors.black),
            textAlign: TextAlign.left,
          ),
        ),
      ),
    );
  }

  Widget _buildStarCast(List<String> cast) {
    return Text(
      cast.join(', '),
      style: const TextStyle(fontSize: 14.0, color: Colors.grey),
    );
  }

  Widget _buildCheckTheatresButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TheatersListScreen(
                movieTitle: movieTitle,
                movieId: movieId,
                
              ),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.redAccent,
          padding: const EdgeInsets.symmetric(horizontal: 120.0, vertical: 15),
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
