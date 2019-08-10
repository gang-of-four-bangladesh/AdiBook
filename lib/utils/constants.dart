class FirestorePath {
  static const String InstructorCollection = 'instructors';
  static const String UserCollection = 'users';
  static const String PupilCollection = 'pupils';
  static const String LessionCollection = 'lessons';
  static const String PupilsOfAnInstructorCollection =
      '$InstructorCollection/%s/$PupilCollection';
  static const String InstructorsOfAPupilColection =
      '$PupilCollection/%s/$InstructorCollection';
  static const String LessonsOfAPupilColection =
      '$PupilCollection/%s/$LessionCollection';
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
}

class SharedPreferenceKeys {
  static const String InstructorIdKey = 'instructor_id_key';
  static const String HasInstructorVerifiedKey = 'has_instructor_verified_key';
  static const String LoggedInUserIdKey = 'last_logged_in_user_id_key';
  static const String LogFileLastUploadedAtKey =
      'log_file_last_uploaded_at_key';
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

const Map<String, String> CountryWisePhoneCode = {
  "United Kingdom (+44)": "+44",
  "Bangladesh (+880)": "+880"
};

enum RunningMode {
  Debug,
  Release,
  Profile,
}
enum UserType {
  Pupil,
  Instructor,
  Admin,
}
enum VehicleType {
  Manual,
  Automatic,
}
enum LessionType {
  Lession,
  DrivingTest,
  MockTest,
  PassPlus,
  Refresher,
  Motorway
}
