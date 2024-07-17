import 'package:flutter/material.dart';
import 'package:ticketmart/theatres_list_screen.dart';

class MovieDetailsScreen extends StatelessWidget {
  final String movieTitle;
  final String imageUrl; // Assuming you pass the image URL for the movie

  const MovieDetailsScreen({super.key, required this.movieTitle, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(movieTitle),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
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
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.network(
                        imageUrl,
                        height: 300.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black87],
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10.0),
                        bottomRight: Radius.circular(10.0),
                      ),
                    ),
                    child: Text(
                      movieTitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              const Text(
                'Date: July 17, 2024', // Replace with actual date
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
              ),
              const SizedBox(height: 10.0),
              const Text(
                'Time: 19:30', // Replace with actual time
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
              ),
              const SizedBox(height: 10.0),
              const Text(
                'Cinema: ABC Cinema Hall', // Replace with actual cinema name
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
              ),
              const SizedBox(height: 10.0),
              const Text(
                'Seat: A12', // Replace with actual seat number
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                         TheatersListScreen(imageUrl: imageUrl, movieTitle: movieTitle ),
                  ),
                );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Text(
                  'Book Tickets',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
