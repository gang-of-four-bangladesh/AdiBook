import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationToken {
  Future<String> getToken() async{
    String tokenStr;
    FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
     tokenStr = await _firebaseMessaging.getToken().then((token) {
       return token.toString();
      // do whatever you want with the token here
    });
    return tokenStr;
  }
}
