import 'package:adibook/core/app_data.dart';
import 'package:adibook/core/constants.dart';
import 'package:adibook/data/pupil_manager.dart';
import 'package:adibook/models/instructor.dart';
import 'package:adibook/models/pupil.dart';
import 'package:adibook/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logging/logging.dart';

class UserManager {
  Logger _logger = Logger('UserManager=>createUser');
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

  Future<bool> pupilExists(String id, UserType userType) async {
    var pupil = await Pupil(id: id).get();
    if (!pupil.exists)
      return false;
    else
      return true;
  }

  Future<void> createUser(
      {String id,
      UserType userType = UserType.Instructor,
      String token}) async {
    if (await userExists(id, userType)) {
      this._logger.info('User creation skipped. User $id already exits.');
      //Update user login type and token.
      await User(
        id: id,
        userType: userType,
        userToken: token,
      ).update();
      this
          ._logger
          .info('Updated user logged in type $userType and token $token.');
      return;
    }
    await User(
      id: id,
      phoneNumber: id,
      userType: userType,
      userToken: token,
      isVerified: true,
    ).add();
    if (userType == UserType.Instructor) {
      await Instructor(id: id, phoneNumber: id).add();
    } else {
      if(!await pupilExists(id,userType))
      await Pupil(id: id, phoneNumber: id).add();
    }
    this._logger.info('User of type $userType with $id created.');
  }

  Future<void> updateAppDataByUser(User adiBookUser) async {
    appData.user = adiBookUser;
    if (adiBookUser.userType == UserType.Instructor) {
      appData.instructor = await Instructor(id: adiBookUser.id).getInstructor();
    } else if (adiBookUser.userType == UserType.Pupil) {
      appData.pupil = await Pupil(id: adiBookUser.id).getPupil();
      appData.instructor =
          await PupilManager().getDefaultInstructor(appData.pupil.id);
    }
  }

  Future<void> updateAppDataByUserId(String userId) async {
    var adiBookUser = await User(id: userId).getUser();
    await updateAppDataByUser(adiBookUser);
  }

  bool hasExpired(DateTime expiryDate) {
    if (expiryDate == null) return false;
    var difference = DateTime.now().difference(expiryDate).inSeconds;
    this._logger.info(
        'User expire date $expiryDate, current date ${DateTime.now()}, difference $difference seconds.');
    return difference > 0;
  }

  Future<bool> hasUserExpired(String userId) async {
    var user = await User(id: userId).getUser();
    return hasExpired(user.expiryDate);
  }
}
