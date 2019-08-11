import 'package:adibook/models/instructor.dart';
import 'package:adibook/models/pupil.dart';
import 'package:adibook/models/user.dart';
import 'package:adibook/pages/instructor_home_page.dart';
import 'package:adibook/pages/pupil_home_page.dart';
import 'package:adibook/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
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

  Future<bool> userExists(String id) async {
    var user = await User(id: id).getUser();
    if (user == null) return false;
    if (user.userType == UserType.Instructor &&
        await Instructor(id: id).getInstructor() == null) return false;
    if (user.userType == UserType.Pupil &&
        await Pupil(id: id).getPupil() == null) return false;
    return true;
  }

  Future<void> createUser(
      {String id, UserType userType = UserType.Instructor}) async {
    Logger _logger = Logger('UserManager=>createUser');
    if (!await userExists(id)) {
      await User(id: id, userType: userType).add();
      userType == UserType.Instructor
          ? await Instructor(id: id).add()
          : await Pupil(id: id).add();
      _logger.info('User of type $userType with $id created.');
    }
    _logger.info('User creation skipped. User $id already exits.');
  }

  String landingPagePathOnUserType(UserType userType) {
    return userType == UserType.Pupil
        ? PageRoutes.PupilHomePage
        : PageRoutes.HomePage;
  }

  Widget landingPageOnUserType(UserType userType) {
    return userType == UserType.Pupil
        ? PupilHomePage()
        : InstructorHomePage();
  }
}
