import 'dart:convert';

import 'package:ticketmart/model/login/login_request.dart';
import 'package:http/http.dart' as http;

import '../../model/login/login_response.dart';
import '../../utils/api_string.dart';

class LoginRespository {
  static Future<LoginResponse> login(String email, String mobile) async {
    LoginRequest loginRequest = LoginRequest(email: email, mobile: mobile);

    final response = await http.post(
      Uri.parse(ApiString.loginUrl),
      body: loginRequest.toJson(),
    );

    if (response.statusCode == 200) {
      return LoginResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('API error: ${response.statusCode}');
    }
  }
}
