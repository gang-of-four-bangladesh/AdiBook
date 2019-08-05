import 'package:adibook/models/instructor.dart';
import 'package:adibook/models/pupil.dart';
import 'package:adibook/models/user.dart';
import 'package:adibook/utils/constants.dart';
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

  static Future<bool> userExists(String id) async {
    var user = await User(id: id).getUser();
    if (user == null) return false;
    if (user.userType == UserType.Instructor &&
        await Instructor(id: id).getInstructor() == null) return false;
    if (user.userType == UserType.Pupil &&
        await Pupil(id: id).getPupil() == null) return false;
    return true;
  }

  static Future<void> createUser(
      {String id, UserType userType = UserType.Instructor}) async {
    if (!await userExists(id)) {
      await User(id: id, userType: userType).add();
      userType == UserType.Instructor
          ? await Instructor(id: id).add()
          : await Pupil(id: id).add();
    }
  }
}
