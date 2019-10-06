import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';

class PushNotificationToken {
  FirebaseMessaging _firebaseMessaging;
  Logger _logger;
  PushNotificationToken() {
    _logger = Logger('PushNotifier');
    _firebaseMessaging = FirebaseMessaging();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        this._logger.info("onMessage: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        this._logger.info("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        this._logger.info("onResume: $message");
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      this._logger.info("Settings registered: $settings");
    });
  }
  Future<String> getToken() async {
    return await _firebaseMessaging.getToken();
  }
}

class Messaging {
  static final Client client = Client();

  // from 'https://console.firebase.google.com'
  // --> project settings --> cloud messaging --> "Server ke
  static const String serverKey =
      'AAAAfY9D6eo:APA91bEAerZZcGuGM-4jJDZwbbBwoiLZsHpxXzAsUBFYWrczghSOGt2OobwycAvxh5UBi0KwRQs_itUAgp45cUdELevoQyGKz0QxTaF_p5afY0lptCYjRETnNhK3S5nJOhHJt-u8KuZD';

  static Future<Response> sendToAll({
    @required String title,
    @required String body,
  }) =>
      sendToTopic(title: title, body: body, topic: 'all');

  static Future<Response> sendToTopic(
          {@required String title,
          @required String body,
          @required String topic}) =>
      sendTo(title: title, body: body, fcmToken: '/topics/$topic');

  static Future<Response> sendTo({
    @required String title,
    @required String body,
    @required String fcmToken,
  }) =>
      client.post(
        'https://fcm.googleapis.com/fcm/send',
        body: json.encode({
          'notification': {'body': '$body', 'title': '$title'},
          'priority': 'high',
          'data': {
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done',
          },
          'to': 'ediDFKizuGM:APA91bESXl1wm-G-q6-Vso-IhHsgjn6C7nA3J9RnSKjiNczbkWEne5KiewXJ2Di8wgkawSi6liweGqWHr2nSGjjXRHlanl6APK65E1ADm6CVmc5j_Phxn__LOC0twomrzWPfM7QQCC2t',
        }),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverKey',
        },
      );
}
