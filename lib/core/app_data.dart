import 'package:adibook/models/instructor.dart';
import 'package:adibook/models/pupil.dart';
import 'package:adibook/models/user.dart';
class AppData {
  static final AppData _appData = new AppData._internal();

  Map<String, dynamic> contextualInfo;
  Pupil pupil;
  Instructor instructor;
  User user;

  factory AppData() {
    return _appData;
  }

  AppData._internal();
}

final appData = AppData();
