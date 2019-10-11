import 'package:adibook/core/constants.dart';
import 'package:adibook/models/user.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';

class FirebaseCloudMessaging {
  static final _firebaseMessaging = FirebaseMessaging();
  static final Logger _logger = Logger('firebase_cloud_messaging');

  static Future<void> setupNotification() async {
    _firebaseMessaging.configure(
      onMessage: onMessageHandler,
      onLaunch: onLaunchHandler,
      onResume: onResumeHandler,
    );
    _firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(
        sound: true,
        badge: true,
        alert: true,
      ),
    );
    _firebaseMessaging.onIosSettingsRegistered.listen(
      (IosNotificationSettings settings) {
        _logger.info("Settings registered: $settings");
      },
    );
  }

  static Future onMessageHandler(Map<String, dynamic> message) async {
    _logger.info('notification message received with data $message');
  }

  static Future onLaunchHandler(Map<String, dynamic> message) async {
    _logger.info('notification message lunch the app. Received data $message');
  }

  static Future onResumeHandler(Map<String, dynamic> message) async {
    _logger
        .info('notification message resumed the app. Received data $message');
  }

  static Future<String> getToken() async {
    return await _firebaseMessaging.getToken();
  }
}

class PushNotificationSender {
  static Future<Response> send({
    @required String userId,
    @required String title,
    @required String body,
  }) async {
    var postUrl = 'https://fcm.googleapis.com/fcm/send';
    final String _serverKey =
        'AAAAfY9D6eo:APA91bEAerZZcGuGM-4jJDZwbbBwoiLZsHpxXzAsUBFYWrczghSOGt2OobwycAvxh5UBi0KwRQs_itUAgp45cUdELevoQyGKz0QxTaF_p5afY0lptCYjRETnNhK3S5nJOhHJt-u8KuZD';

    var user = await User(id: userId).getUser();
    if (user == null || user.userToken == null || user.userToken == EmptyString) return null;
    return Client().post(
      postUrl,
      body: json.encode(
        {
          'notification': {
            'body': '$body',
            'title': '$title',
          },
          'priority': 'high',
          'to': user.userToken
        },
      ),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'key=$_serverKey',
      },
    );
  }
}
