import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ticketmart/model/seat/seat_layout_req.dart';

import '../model/seat/seat_layout_res.dart';
import '../utils/api_string.dart';
import '../utils/app_string.dart';

class SeatLayoutProvider {
  static Future<SeatData?> seatLayout(
    int iD,
    int showTimeId,
    int stageID,
  ) async {
    SeatLayoutRequest seatLayoutRequest =
        SeatLayoutRequest(id: iD, showtimeId: showTimeId, stageId: stageID);
    try {
      final response = await http.post(Uri.parse(ApiString.seatLayout),
          headers: AppString.header,
          body: jsonEncode(seatLayoutRequest.toJson()));

      if (response.statusCode != 200) {
        throw Exception('Server Error Code ${response.statusCode} ');
      }
      final decode = SeatLayoutResponse.fromJson(jsonDecode(response.body));

      if (decode.status) {
        return decode.data!;
      } else {
        throw Exception('Response Error: ${decode.message}');
      }
    } catch (e) {
      throw Exception('API error: $e');
    }
  }
}
