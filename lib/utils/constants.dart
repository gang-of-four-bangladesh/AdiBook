import 'package:flutter/material.dart';

class FirestorePath {
  static const String InstructorCollection = 'instructors';
  static const String UserCollection = 'users';
  static const String PupilCollection = 'pupils';
  static const String LessionCollection = 'lessons';
  static const String ProgressPlanCollection = 'progress_plan';
  static const String PupilsOfAnInstructorCollection =
      '$InstructorCollection/%s/$PupilCollection';
  static const String InstructorsOfAPupilColection =
      '$PupilCollection/%s/$InstructorCollection';
  static const String LessonsOfAPupilColection =
      '$PupilCollection/%s/$InstructorCollection/%s/$LessionCollection';
  static const String ProgressPlanOfAPupilColection =
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

SectionType defaultSectionType(UserType userType) {
  return _getUsersSectionsConfig()
      .firstWhere((f) => f.userType == userType && f.isDefault)
      .sectionType;
}

List<_UsersSectionType> _getUsersSectionsConfig() {
  return [
    _UsersSectionType(
      userType: UserType.Admin,
      sectionType: SectionType.AdminActivity,
      isDefault: true,
    ),
    _UsersSectionType(
      userType: UserType.Instructor,
      sectionType: SectionType.InstructorActivity,
      isDefault: true,
    ),
    _UsersSectionType(
      userType: UserType.Instructor,
      sectionType: SectionType.InstructorActivityForPupil,
      isDefault: false,
    ),
    _UsersSectionType(
      userType: UserType.Pupil,
      sectionType: SectionType.PupilActivity,
      isDefault: true,
    )
  ];
}

class _UsersSectionType {
  _UsersSectionType({
    this.userType,
    this.sectionType,
    this.isDefault,
  });
  UserType userType;
  SectionType sectionType;
  bool isDefault;
}

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
