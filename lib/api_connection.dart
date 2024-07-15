import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiConnection {
  static const String baseUrl ="https://69.16.233.70/public/flutter-app"; // Replace with your server address
  static const String userEndpoint = "/user";

  static String get ticket => "$baseUrl$userEndpoint/ticket.php";
  static String get dataUrl => "$baseUrl$userEndpoint/profile_modal.php";


  static Future<List<String>> fetchCarouselImages() async {
    final response = await http.get(Uri.parse(ticket));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<String>.from(data['images']);
    } else {
      throw Exception('Failed to load images');
    }
  }

   static Future<List<String>> fetchNewReleases() async {
    final response = await http.get(Uri.parse(ticket));
    if (response.statusCode == 200) {
      return List<String>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load new releases');
    }
  }

  static Future<List<String>> fetchTrendingInTheatre() async {
    final response = await http.get(Uri.parse(ticket));
    if (response.statusCode == 200) {
      return List<String>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load trending in theatre');
    }
  }

  static Future<List<String>> fetchUpcoming() async {
    final response = await http.get(Uri.parse(ticket));
    if (response.statusCode == 200) {
      return List<String>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load upcoming movies');
    }
  }

    static Future<List<Map<String, dynamic>>> fetchData(String dataType) async {
    try {
      final response = await http.post(
        Uri.parse(dataUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'dataType': dataType}),
      );

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        // Assuming responseData is a list of maps containing name and URL
        return List<Map<String, dynamic>>.from(responseData);
      } else {
        throw Exception('Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching data: $e');
      }
      throw Exception('Failed to fetch data: $e');
    }
  }

  // Add other API functions here as needed
}
