class FirestorePath {
  static const String Instructor = 'instructors';
  static const String Pupils = 'pupils';
  static const String User = 'users';
  static const String PupilsOfAnInstructor = '$Instructor/%s/pupils';
}

class PageRoutes {
  static const String HomePage = '/home';
  static const String LoginPage = '/login';
  static const String PupilRegistrationPage = '/pupil_registration';
  static const String ImageUploadPage = '/image_upload';
}

class SharedPreferenceKeys {
  static const String InstructorIdKey = 'instructor_id_key';
  static const String HasInstructorVerifiedKey = 'has_instructor_verified_key';
  static const String LoggedInUserIdKey = 'last_logged_in_user_id_key';
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

enum RunningMode { Debug, Release, Profile }
enum UserType { Pupil, Instructor, Admin }
