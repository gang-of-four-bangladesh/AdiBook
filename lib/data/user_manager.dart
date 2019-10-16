import 'package:adibook/core/app_data.dart';
import 'package:adibook/core/constants.dart';
import 'package:adibook/data/pupil_manager.dart';
import 'package:adibook/models/instructor.dart';
import 'package:adibook/models/pupil.dart';
import 'package:adibook/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logging/logging.dart';

class UserManager {
  Future<String> get currentUserId async {
    var user = await FirebaseAuth.instance.currentUser();
    if (user == null) return null;
    return user.phoneNumber;
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
    if (!user.exists) return false;
    if (userType == UserType.Instructor) {
      var instructor = await Instructor(id: id).get();
      return instructor.exists;
    }
    if (userType == UserType.Pupil) {
      var pupil = await Pupil(id: id).get();
      return pupil.exists;
    }
    return true;
  }

  Future<void> createUser(
      {String id,
      UserType userType = UserType.Instructor,
      String token}) async {
    Logger _logger = Logger('UserManager=>createUser');
    if (!await userExists(id, userType)) {
      await User(
        id: id,
        phoneNumber: id,
        userType: userType,
        userToken: token,
        isVerified: true,
      ).add();
      userType == UserType.Instructor
          ? await Instructor(id: id, phoneNumber: id).add()
          : await Pupil(id: id, phoneNumber: id).add();
      _logger.info('User of type $userType with $id created.');
    }
    _logger.info('User creation skipped. User $id already exits.');
  }

  Future<void> updateAppDataByUser(User adiBookUser) async {
    Logger _logger = Logger('UserManager=>updateAppDataByUser');
    appData.userType = adiBookUser.userType;
    if (adiBookUser.userType == UserType.Instructor) {
      appData.instructorId = adiBookUser.id;
    } else if (adiBookUser.userType == UserType.Pupil) {
      appData.pupilId = adiBookUser.id;
      var instructor =
          await PupilManager().getDefaultInstructor(adiBookUser.id);
      appData.instructorId = instructor.id;
    }
    _logger.info(
        'updated app data information, instructor id: ${appData.instructorId}, pupil id ${appData.pupilId} and user type ${appData.userType}.');
  }

  Future<void> updateAppDataByUserId(String userId) async {
    var adiBookUser = await User(id: userId).getUser();
    updateAppDataByUser(adiBookUser);
  }

  bool hasExpired(DateTime expiryDate) {
    if (expiryDate == null) return false;
    return DateTime.now().difference(expiryDate).inSeconds > 0;
  }

  Future<bool> hasUserExpired(String userId) async {
    var user = await User(id: userId).getUser();
    return hasExpired(user.expiryDate);
  }
}
