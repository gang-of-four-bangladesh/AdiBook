import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:meta/meta.dart';

class PushNotificationToken {
  Future<String> getToken() async {
    String tokenStr;
    FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    tokenStr = await _firebaseMessaging.getToken().then((token) {
      return token.toString();
      // do whatever you want with the token here
    });
    return tokenStr;
  }
}

class Messaging {
  static final Client client = Client();

  // from 'https://console.firebase.google.com'
  // --> project settings --> cloud messaging --> "Server key"
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
          'to': '$fcmToken',
        }),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverKey',
        },
      );
}
