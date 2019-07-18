class FirestorePath {
  static const String UsersCollection = 'users';
}

class PagePath {
  static const String HomePage = '/home';
  static const String LoginPage = '/login';
}

class SharedPreferenceKeys {
  static const String VerifiedPhoneNumberList = 'VerifiedPhoneNumberList';
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
