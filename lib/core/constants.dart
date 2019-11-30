import 'package:flutter/material.dart';

class FirestorePath {
  static const String InstructorCollection = 'instructors';
  static const String UserCollection = 'users';
  static const String PupilCollection = 'pupils';
  static const String LessionCollection = 'lessons';
  static const String PaymentCollection = 'payments';
  static const String ProgressPlanCollection = 'progress';
  static const String LessonEventsCollection = 'lesson_events';
  static const String PaymentEventsCollection = 'payment_events';
  static const String PupilsOfAnInstructorCollection =
      '$InstructorCollection/%s/$PupilCollection';
  static const String InstructorsOfAPupilColection =
      '$PupilCollection/%s/$InstructorCollection';
  static const String LessonsOfAPupilColection =
      '$PupilCollection/%s/$InstructorCollection/%s/$LessionCollection';
  static const String PaymentsOfAPupilColection =
      '$PupilCollection/%s/$InstructorCollection/%s/$PaymentCollection';
  static const String ProgressPlanOfAPupilCollection =
      '$PupilCollection/%s/$InstructorCollection/%s/$ProgressPlanCollection';
  static const String LessonEventsOfAInstructorCollection =
      '$InstructorCollection/%s/$LessonEventsCollection';
}

class StoragePath {
  static const String LogsFolder = '/logs';
  static const String UserLogsFolder = '$LogsFolder/%s';
  static const String AppDocumentsFolder = '/app_docs';
  static const String DrivingLicenseFolder = '/driving_license';
  static const String LessonsFolder = '$AppDocumentsFolder/lessons';
  static const String PupilsFolder =
      '$AppDocumentsFolder/pupils/$DrivingLicenseFolder';
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
  static const String LessonIdKey = 'lesson_id_key';
  static const String PaymentIdKey = 'payment_id_key';
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

const String EmptyString = '';

class AppTheme {
  static Color appThemeColor =
      Colors.lightBlueAccent.withRed(3).withGreen(209).withBlue(191);
  static Color calendarEventPendingColor = Colors.greenAccent;
}

const Map<String, String> CountryWisePhoneCode = {
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

enum TripLocation {
  None,
  Home,
  Work,
  School,
  College,
}
enum VehicleType {
  None,
  Manual,
  Automatic,
}
enum LessonType {
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
  Prompted,
  RarelyPrompted,
  Independent
}

enum ConfirmAction { CANCEL, ACCEPT }

enum PaymentType { Cash, Card, Cheque }

enum OperationMode { New, Edit }

enum DisplayArea { None, Drawer, Tab }

bool isNullOrEmpty<T>(T value) {
  if (value is String) return value == null || value.isEmpty;
  return value == null;
}

bool isNotNullOrEmpty<T>(T value) {
  return !isNullOrEmpty(value);
}

const TripLocationData = [
  {
    "display": "Home",
    "value": 1,
  },
  {
    "display": "Work",
    "value": 2,
  },
  {
    "display": "School",
    "value": 3,
  },
  {
    "display": "College",
    "value": 4,
  }
];

const VehicleTypeData = [
  {
    "display": "Manual",
    "value": 1,
  },
  {
    "display": "Automatic",
    "value": 2,
  }
];

const LessonTypeData = [
  {
    "display": "Lession",
    "value": 1,
  },
  {
    "display": "Driving Test",
    "value": 2,
  },
  {
    "display": "Mock Test",
    "value": 3,
  },
  {
    "display": "Pass Plus",
    "value": 4,
  },
  {
    "display": "Refresher",
    "value": 5,
  },
  {
    "display": "Motorway",
    "value": 6,
  }
];
