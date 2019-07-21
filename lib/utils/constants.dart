class DatabaseDocumentPath {
  static const String InstructorCollection = 'instructors';
  static const String PupilsCollection = '$InstructorCollection/%s/pupils';
}

class PagePath {
  static const String HomePage = '/home';
  static const String LoginPage = '/login';
}

class SharedPreferenceKeys {
  static const String InstructorId = 'instructor_id';
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
