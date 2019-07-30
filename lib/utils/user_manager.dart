import 'package:adibook/models/user.dart';
import 'package:adibook/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserManager {
  static Future<String> get currentUserId async {
    var preferences = await SharedPreferences.getInstance();
    return preferences.getString(SharedPreferenceKeys.LoggedInUserIdKey);
  }

  static Future<User> get currentUser async {
    return new User(id: await UserManager.currentUserId);
  }

  static Future<bool> logout() async {
    var user = await UserManager.currentUser;
    user.isVerified = false;
    user.update();
    var preferences = await SharedPreferences.getInstance();
    return preferences.remove(SharedPreferenceKeys.LoggedInUserIdKey);
  }
}
