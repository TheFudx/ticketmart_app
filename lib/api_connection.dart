import 'package:http/http.dart' as http;
import 'dart:convert';

import 'utils/api_string.dart';

class ApiConnection {
  static Future<List<Map<String, dynamic>>> fetchCarouselImages() async {
    final response = await http.get(Uri.parse(ApiString.movies));

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

  static Future<List<Map<String, dynamic>>> fetchNewReleases() async {
    final response = await http.get(Uri.parse(ApiString.movies));

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
    final response = await http.get(Uri.parse(ApiString.movies));

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
    final response =
        await http.get(Uri.parse('${ApiString.theatres}?movie_id=$movieId'));

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
    final response = await http.get(Uri.parse(ApiString.screens));
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
}
