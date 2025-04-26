import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../model/profile/userprofile_req.dart';
import '../../model/profile/userprofile_response.dart';
import '../../utils/api_string.dart';

class ProfileServices {
  static Future<UserProfileResp?> fetchProfile(UserprofileReq user) async {
    try {
      final response = await http.post(Uri.parse(ApiString.userProfile),
          body: user.toJson());
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return UserProfileResp.fromJson(data);
      } else {
        throw Exception('Error: ${response.statusCode}');
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error fetching profile data: $e');
      return null;
    }
  }
}
