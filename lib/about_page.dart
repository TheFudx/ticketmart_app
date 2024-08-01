import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About', style: TextStyle(fontWeight: FontWeight.bold),)),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to TicketMart, your ultimate destination for booking tickets to a world of entertainment and experiences! Whether you’re looking for tickets for movies, concerts, sports events, theater performances, or special attractions, we’ve got you covered.',
              style: TextStyle(fontSize: 12.0),
            ),
            SizedBox(height: 20.0),
            Text(
              'Who Are We',
              style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold, color: Colors.blueAccent),
            ),
            SizedBox(height: 8.0),
            Text(
              'We believe that events are more than just occasions; they are moments that create lasting memories. Our dedicated team works tirelessly to ensure that you have access to the best events happening around you, with a seamless and enjoyable booking process.',
              style: TextStyle(fontSize: 12.0),
            ),
            SizedBox(height: 20.0),
            Text(
              'What We Offer',
              style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold, color: Colors.blueAccent),
            ),
            SizedBox(height: 8.0),
            Text(
              'Wide Selection of Events:',
              style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold, color: Colors.blueAccent),
            ),
            Text(
              'From local shows to international tours, we offer tickets to a diverse range of events to suit every taste and interest.',
              style: TextStyle(fontSize: 12.0),
            ),
            SizedBox(height: 8.0),
            Text(
              'User-Friendly Interface:',
              style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold, color: Colors.blueAccent),
            ),
            Text(
              'Our website and app are designed to provide you with a smooth and hassle-free booking experience, with easy navigation and secure payment options.',
              style: TextStyle(fontSize: 12.0),
            ),
            SizedBox(height: 8.0),
            Text(
              'Exclusive Deals:',
              style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold, color: Colors.blueAccent),
            ),
            Text(
              'Enjoy special discounts and offers on a variety of events. Be the first to know about upcoming shows and limited-time promotions by signing up for our newsletter.',
              style: TextStyle(fontSize: 12.0),
            ),
            SizedBox(height: 8.0),
            Text(
              'Customer Support:',
              style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold, color: Colors.blueAccent),
            ),
            Text(
              'Our customer support team is always ready to assist you with any queries or issues you may have. We are committed to ensuring that your experience with us is nothing short of excellent.',
              style: TextStyle(fontSize: 12.0),
            ),
            SizedBox(height: 20.0),
            Text(
              'Our Mission',
              style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold, color: Colors.blueAccent),
            ),
            SizedBox(height: 8.0),
            Text(
              'Our mission is to make event-going a delightful experience for everyone. We strive to bring joy and excitement to our customers by connecting them with the events they love. Whether you are a fan of music, sports, theater, or any other form of entertainment, TicketMart is here to make your event experience unforgettable.',
              style: TextStyle(fontSize: 12.0),
            ),
            SizedBox(height: 20.0),
            Text(
              'Join Us',
              style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold, color: Colors.blueAccent),
            ),
            SizedBox(height: 8.0),
            Text(
              'Become a part of the TicketMart community and never miss out on the fun! Download our app or visit our website to explore the latest events and book your tickets today.',
              style: TextStyle(fontSize: 12.0),
            ),
          ],
        ),
      ),
    );
  }
}
