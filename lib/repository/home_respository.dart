import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../model/app_version.dart';
import '../model/home/home_model.dart';
import 'package:http/http.dart' as http;

import '../model/home/show_model.dart';
import '../utils/api_string.dart';
import '../views/home/drawer/widget/home_widget.dart';

class HomeRespository {
  static Future<List<ComedyShow?>> homeProvider() async {
    try {
      final response = await http.get(Uri.parse(ApiString.homePageUrl));

      if (response.statusCode == 200) {
        final decode = HomeModel.fromJson(jsonDecode(response.body));
        return decode.data.comedyShows;
      } else {
        throw Exception('Server Error Code ${response.statusCode} ');
      }
    } catch (e) {
      throw Exception('API error: $e');
    }
  }

  static Future<List<Showtime?>> fetchShowtimes(int showId) async {
    try {
      final response = await http.post(Uri.parse(ApiString.showtimeUrl),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'id': showId}));

      if (response.statusCode == 200) {
        final decode = jsonDecode(response.body);
        final value = ShowModel.fromJson(decode);
        if (!value.status) return [];
        return value.data.showtimes;
      } else {
        throw Exception('Server Error Code ${response.statusCode} ');
      }
    } catch (e) {
      throw Exception('API error: $e');
    }
  }

  static Future<void> appVersionChecker(BuildContext context) async {
    AppVersion? latestVersion;
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String? currentVersion = packageInfo.version;
    String? platform =
        Platform.isAndroid ? ApiString.appAndroid : ApiString.appIos;

    try {
      final response = await http.get(Uri.parse(ApiString.appVersionChecker));
      if (response.statusCode != 200) return;

      final Map<String, dynamic> data = json.decode(response.body);
      latestVersion = AppVersion.fromJson(data[platform]);

      if (latestVersion.versionName != currentVersion && latestVersion.released)
        showUpdateDialogBox(context);
    } catch (e) {
      log(e.toString());
    }
  }
}
