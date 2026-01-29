import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ticketmart/utils/api_string.dart';

import '../../model/profile/profile_res_model.dart';
import '../../storage/shared_pref_helper.dart';

class UserProfileRespository {
  static Future<ProfileResponse> fetchProfile() async {
    final token = await SharedPrefHelper.getUserToken();

    final response = await http.post(
      Uri.parse(ApiString.profile),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode != 200) {
      throw Exception('API error: ${response.statusCode}');
    }

    return ProfileResponse.fromJson(jsonDecode(response.body));
  }
}
