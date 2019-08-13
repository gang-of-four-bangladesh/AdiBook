import 'package:adibook/models/instructor.dart';
import 'package:adibook/models/pupil.dart';
import 'package:adibook/models/user.dart';
import 'package:adibook/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logging/logging.dart';

class UserManager {
  Future<String> get currentUserId async {
    var user = await FirebaseAuth.instance.currentUser();
    if (user == null) return null;
    return user.uid;
  }

  Future<User> get currentUser async {
    var userId = await currentUserId;
    if (userId == null) return null;
    return User(id: userId).getUser();
  }

  Future<UserType> get currentUserType async {
    var user = await currentUser;
    return user.userType;
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<bool> userExists(String id, UserType userType) async {
    var user = await User(id: id).get();
    if (user.data == null) return false;
    if (userType == UserType.Instructor) {
      var instructor = await Instructor(id: id).get();
      if (instructor.data == null) return false;
    }
    if (userType == UserType.Pupil) {
      var pupil = await Pupil(id: id).get();
      if (pupil == null) return false;
    }
    return true;
  }

  Future<void> createUser(
      {String id, UserType userType = UserType.Instructor}) async {
    Logger _logger = Logger('UserManager=>createUser');
    if (!await userExists(id, userType)) {
      await User(id: id, userType: userType).add();
      userType == UserType.Instructor
          ? await Instructor(id: id).add()
          : await Pupil(id: id).add();
      _logger.info('User of type $userType with $id created.');
    }
    _logger.info('User creation skipped. User $id already exits.');
  }
}
