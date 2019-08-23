import 'package:flutter/material.dart';

class FirestorePath {
  static const String InstructorCollection = 'instructors';
  static const String UserCollection = 'users';
  static const String PupilCollection = 'pupils';
  static const String LessionCollection = 'lessons';
  static const String ProgressPlanCollection = 'progress';
  static const String PupilsOfAnInstructorCollection =
      '$InstructorCollection/%s/$PupilCollection';
  static const String InstructorsOfAPupilColection =
      '$PupilCollection/%s/$InstructorCollection';
  static const String LessonsOfAPupilColection =
      '$PupilCollection/%s/$InstructorCollection/%s/$LessionCollection';
  static const String ProgressPlanDocumentPath =
      '$PupilCollection/%s/$InstructorCollection/%s/$ProgressPlanCollection';
}

class StoragePath {
  static const String LogsFolder = '/logs';
  static const String UserLogsFolder = '$LogsFolder/%s';
}

class PageRoutes {
  static const String HomePage = '/home';
  static const String LoginPage = '/login';
  static const String PupilRegistrationPage = '/pupil_registration';
  static const String ImageUploadPage = '/image_upload';
  static const String PupilActivity = '/pupil_activity';
  static const String PupilHomePage = '/pupil_home_page';
  static const String ProgressPlannerPage = '/progress_planner';
}

class SharedPreferenceKeys {
  static const String InstructorIdKey = 'instructor_id_key';
  static const String HasInstructorVerifiedKey = 'has_instructor_verified_key';
  static const String LoggedInUserIdKey = 'last_logged_in_user_id_key';
  static const String LogFileLastUploadedAtKey =
      'log_file_last_uploaded_at_key';
}

class DataSharingKeys {
  static const String PupilIdKey = 'pupil_id_key';
  static const String InstructorIdKey = 'instructor_id_key';
  static const String UserTypeKey = 'user_type';
}

class EnvironmentStatus {
  static RunningMode get applicationRunMode {
    if (bool.fromEnvironment("dart.vm.product")) return RunningMode.Release;
    if (_isInDebugMode()) return RunningMode.Debug;
    return RunningMode.Profile;
  }

  static bool _isInDebugMode() {
    bool inDebugMode = false;
    assert(inDebugMode = true);
    return inDebugMode;
  }
}

class AppTheme {
  static Color appThemeColor = Colors.lightBlueAccent.withRed(3).withGreen(209).withBlue(191);
}

const Map<String, String> CountryWisePhoneCode = {
  "United Kingdom (+44)": "+44",
  "Bangladesh (+880)": "+880"
};

const Map<String, String> CountryWisePhoneCode2 = {
  "UK (+44)": "+44",
  "BD (+880)": "+880"
};

enum RunningMode {
  None,
  Debug,
  Release,
  Profile,
}
enum UserType {
  None,
  Pupil,
  Instructor,
  Admin,
}

enum TripLocation{
  Home,
  Work,
  School,
  College
}
enum VehicleType {
  None,
  Manual,
  Automatic,
}
enum LessionType {
  None,
  Lession,
  DrivingTest,
  MockTest,
  PassPlus,
  Refresher,
  Motorway
}
enum SectionType {
  None,
  InstructorActivity,
  InstructorActivityForPupil,
  PupilActivity,
  AdminActivity
}

enum ProgressSubjectStatus {
  None,
  Introduced,
  TalkThrough,
  Prompted,
  RarelyPrompted,
  Independent
}

