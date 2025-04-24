import 'package:http/http.dart' as http;
import 'dart:convert';

import 'model/home/movies_model.dart';

class ApiConnection {
  static const String baseUrl =
      'https://alphastudioz.in/ticketmart-test/public/flutter-app'; // Testing Server

  //    "https://ticketmart.co/public/flutter-app"; // Replace with your server address
  static const String userEndpoint = "/user";
  static const String bookingEndpoint =
      "/booking"; // Add this line for the booking endpoint

  static String get movies => "$baseUrl$userEndpoint/movies.php";
  static String get theatres => "$baseUrl$userEndpoint/theatres.php";
  static String get dataUrl => "$baseUrl$userEndpoint/profile_modal.php";
  static String get seatCount => "$baseUrl$userEndpoint/seat_count.php";
  static String get screens => "$baseUrl$userEndpoint/screen.php";
  static String get users => "$baseUrl$userEndpoint/users.php";
  static String get bookings =>
      "$baseUrl$bookingEndpoint/create_booking.php"; // Add this line for the bookings endpoint
  static String get seats =>
      "$baseUrl$userEndpoint/fetch_seats.php"; // Add this line for the bookings endpoint
  static String get theatresList => "$baseUrl$userEndpoint/theatres_list.php";

  static Future<List<Map<String, dynamic>>> fetchCarouselImages() async {
    final response = await http.get(Uri.parse(movies));

    if (response.statusCode == 200) {
      // Parse the JSON response
      Map<String, dynamic> jsonData = json.decode(response.body);

      // Extract the 'movies' list from the response
      List<dynamic> movieList = jsonData['movies'];

      // Ensure each item in the list is a map
      return movieList.map((item) => item as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to load movies');
    }
  }

  // Copy
  static Future<MovieModel> movieResponse() async {
    final response = await http.get(Uri.parse(movies));

    if (response.statusCode == 200) {
      return MovieModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load movies');
    }
  }

  static Future<List<Map<String, dynamic>>> fetchNewReleases() async {
    final response = await http.get(Uri.parse(movies));

    if (response.statusCode == 200) {
      // Parse the JSON response
      Map<String, dynamic> jsonData = json.decode(response.body);

      // Extract the 'movies' list from the response
      List<dynamic> movieList = jsonData['movies'];

      // Ensure each item in the list is a map
      return movieList.map((item) => item as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to load movies');
    }
  }

  static Future<List<Map<String, dynamic>>> fetchUpcoming() async {
    final response = await http.get(Uri.parse(movies));

    if (response.statusCode == 200) {
      // Parse the JSON response
      Map<String, dynamic> jsonData = json.decode(response.body);

      // Extract the 'movies' list from the response
      List<dynamic> movieList = jsonData['movies'];

      // Ensure each item in the list is a map
      return movieList.map((item) => item as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to load movies');
    }
  }

  static Future<List<Map<String, dynamic>>> fetchScreens(String movieId) async {
    final response = await http.get(Uri.parse('$theatres?movie_id=$movieId'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'error') {
        throw Exception(data['message']);
      }
      return List<Map<String, dynamic>>.from(data['theatres']);
    } else {
      throw Exception('Failed to load theatres');
    }
  }

  static Future<List<Map<String, dynamic>>> fetchSeatCount(
      String screenId) async {
    final response = await http.get(Uri.parse(screens));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data != null && data['seatCount'] != null) {
        return List<Map<String, dynamic>>.from(data['seatCount']);
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to load seat count');
    }
  }

  static Future<Map<String, dynamic>> loginOrRegisterUser(
      String email, String mobileNo) async {
    final response = await http.post(
      Uri.parse(users),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'email': email,
        'mobile_no': mobileNo,
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'success') {
        return {
          'status': 'success',
          'userId': data['user_id']
        }; // Use 'user_id'
      } else {
        throw Exception('Failed to log in or register: ${data['message']}');
      }
    } else {
      throw Exception('Failed to connect to the server');
    }
  }

  static Future<Map<String, dynamic>> createBooking({
    required String userId,
    required String showtimeId,
    required int totalSeats,
    required double totalAmount,
  }) async {
    final response = await http.post(
      Uri.parse(bookings),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'user_id': userId,
        'showtime_id': showtimeId,
        'total_seats': totalSeats.toString(),
        'total_amount': totalAmount.toString(),
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'success') {
        return {'status': 'success', 'message': 'Booking created successfully'};
      } else {
        throw Exception('Failed to create booking: ${data['message']}');
      }
    } else {
      throw Exception('Failed to connect to the server');
    }
  }

  static Future<List<Map<String, dynamic>>> fetchSeats(int screenId) async {
    final response = await http.get(Uri.parse('$seats?screen_id=$screenId'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'error') {
        throw Exception(data['message']);
      }
      return List<Map<String, dynamic>>.from(data['seats']);
    } else {
      throw Exception('Failed to load seats');
    }
  }

  static Future<List<Map<String, dynamic>>> fetchTheatres() async {
    final response = await http.get(Uri.parse(theatresList));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'error') {
        throw Exception(data['message']);
      }
      return List<Map<String, dynamic>>.from(data['theatres']);
    } else {
      throw Exception('Failed to load movies');
    }
  }
}
