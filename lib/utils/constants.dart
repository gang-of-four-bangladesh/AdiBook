class FirestorePath {
  static const String Instructor = 'instructors';
  static const String Pupils = 'pupils';
  static const String User = 'users';
  static const String PupilsOfAnInstructor = '$Instructor/%s/pupils';
}

class PagePath {
  static const String HomePage = '/home';
  static const String LoginPage = '/login';
}

class SharedPreferenceKeys {
  static const String InstructorId = 'instructor_id';
  static const String HasInstructorVerified = 'has_instructor_verified';
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

enum RunningMode { Debug, Release, Profile }
enum UserType { Pupil, Instructor, Admin }
