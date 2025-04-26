import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:ticketmart/theatres_list_screen.dart';

import '../../../model/home/movies.dart';

class MovieDetailsScreen extends StatelessWidget {
  final String topOffers;
  final Movies? movies;
  const MovieDetailsScreen({
    super.key,
    required this.topOffers,
    this.movies,
  });

  @override
  Widget build(BuildContext context) {
    final double imageHeight = MediaQuery.of(context).size.height * 0.2;
    final double imageWidth =
        MediaQuery.of(context).size.width - 40; // Adjust width as needed

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Flexible(
              child: Text(
                movies!.title!,
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis),
                maxLines: 1,
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
                  _buildDescription(movies!.description!),
                  const SizedBox(height: 20.0),
                  _buildSectionTitle('Top Offers for You'),
                  const SizedBox(height: 10),
                  _buildOffersSection(),
                  const SizedBox(height: 20.0),
                  _buildSectionTitle('Star Cast'),
                  const SizedBox(height: 5),
                  _buildStarCast(movies!.cast!.split(',')),
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
              movies!.bannerImagePath!, //  imageUrl,
              fit: BoxFit.fill,
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
                  size: 14.0,
                ),
                const SizedBox(width: 4.0),
                Text(
                  movies!.rating!, // rating,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12.0,
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
        _buildInfoContainer(movies!.duration!),
        _buildSeparator(),
        _buildInfoContainer(movies!.genre!),
        _buildSeparator(),
        _buildInfoContainer(movies!.releaseDate!),
        _buildSeparator(),
        _buildInfoContainer(movies!.id!),
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
        style: const TextStyle(fontSize: 12.0, color: Colors.black),
      ),
    );
  }

  Widget _buildSeparator() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.0),
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
        fontSize: 12.0,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  Widget _buildDescription(String description) {
    return Text(
      description,
      style: const TextStyle(fontSize: 12.0, color: Colors.black),
    );
  }

  Widget _buildOffersSection() {
    return SizedBox(
      height: 60.0, // Adjust height as needed
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          _buildOfferCard(Icons.local_offer, 'HDFC: 10% off on movie tickets'),
          const SizedBox(width: 10.0),
          _buildOfferCard(
              Icons.local_offer, 'Kotak: 15% off on first purchase'),
          const SizedBox(width: 10.0),
          _buildOfferCard(
              Icons.local_offer, 'Axis: 5% cashback on movie tickets'),
        ],
      ),
    );
  }

  Widget _buildOfferCard(IconData icon, String offer) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
      ),
      child: Container(
        width: 300.0, // Adjust width as needed
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, size: 16.0, color: Colors.black),
            const SizedBox(width: 8.0), // Adjust spacing as needed
            Expanded(
              child: Text(
                offer,
                style: const TextStyle(fontSize: 12.0, color: Colors.black),
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStarCast(List<String> cast) {
    return Text(
      cast.join(', '),
      style: const TextStyle(fontSize: 12.0, color: Colors.grey),
    );
  }

  Widget _buildCheckTheatresButton(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: SizedBox(
        width: screenWidth * 0.9, // 80% of screen width

        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TheatersListScreen(
                  movieTitle: movies!.title!,
                  movieId: movies!.id!,
                ),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.blue.shade900,
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.3,
              vertical: 10.0,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: const Text(
            'Check Theatres',
            style: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  void _shareMovie(BuildContext context) {
    final RenderBox box = context.findRenderObject() as RenderBox;
    Share.share(
      'Check out ${movies!.title!} ${movies!.bannerImagePath!}',
      subject: movies!.title!,
      sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,
    );
  }
}
