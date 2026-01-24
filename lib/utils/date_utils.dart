import 'package:intl/intl.dart';

import '../model/login/login_response.dart';
import '../storage/shared_pref_helper.dart';

String getFormattedDate(String? date) {
  if (date == null) {
    return '';
  }
  DateTime parsedDate = DateTime.parse(date);
  DateFormat formatter = DateFormat('dd MMM yyyy');
  return formatter.format(parsedDate);
}

String convert12Format(String? time24) {
  if (time24 == null) {
    return '';
  }
  final DateFormat inputFormat = DateFormat("HH:mm:ss");
  final DateFormat outputFormat = DateFormat("hh:mm a");
  final DateTime dateTime = inputFormat.parse(time24);
  return outputFormat.format(dateTime);
}

String getFormatDayDate(String? date) {
  if (date == null) {
    return '';
  }
  DateTime parsedDate = DateTime.parse(date);
  DateFormat formatter = DateFormat('EEE, dd MMM yyyy');
  return formatter.format(parsedDate);
}

String getFormattedHours(String times) {
  DateFormat inputFormat = DateFormat("HH:mm:ss");
  DateTime parsedDate = inputFormat.parse(times);
  DateFormat outputFormat = DateFormat("h:mm a");
  return outputFormat.format(parsedDate);
}

Future<void> storageData(
  int userId,
  String userEmail,
  String userMobile,
  String userToken,
  User user,
) async {
  await Future.wait([
    SharedPrefHelper.setUserId(userId),
    SharedPrefHelper.setUserEmail(userEmail),
    SharedPrefHelper.setUserMobile(userMobile),
    SharedPrefHelper.setUserToken(userToken),
    SharedPrefHelper.saveUser(user),
  ]);
}
