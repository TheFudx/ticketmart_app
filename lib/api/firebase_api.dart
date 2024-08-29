import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
print('Title: ${message.notification?.title}');
print('Body: ${message.notification?.body}');

print('Payload: ${message.data}');

}
class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    if (kDebugMode) {
      print('Token: $fCMToken');
      FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    }
  }
}