import 'package:adibook/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserManager {
  static Future<String> get currentUserId async {
    var user = await FirebaseAuth.instance.currentUser();
    if (user == null) return null;
    return user.uid;
  }

  static Future<User> get currentUser async {
    var userId = await currentUserId;
    if (userId == null) return null;
    return User(id: userId).getUser();
  }

  static Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }
}
