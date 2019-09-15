import 'package:adibook/core/constants.dart';
class AppData {
  static final AppData _appData = new AppData._internal();

  Map<String, dynamic> contextualInfo;
  String pupilId;
  String instructorId;
  String adminId;
  UserType userType;

  factory AppData() {
    return _appData;
  }

  AppData._internal();
}

final appData = AppData();
