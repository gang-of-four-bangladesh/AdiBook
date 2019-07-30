import 'package:adibook/app.dart';
import 'package:adibook/models/user.dart';
import 'package:adibook/pages/home_page.dart';
import 'package:adibook/pages/login_page.dart';
import 'package:adibook/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future main() async {
  await _setupLogger();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  Widget _defaultPage = LoginPage();

  var preferences = await SharedPreferences.getInstance();
  var keyExists =
      preferences.containsKey(SharedPreferenceKeys.LoggedInUserIdKey);
  if (keyExists) {
    var userId = preferences.getString(SharedPreferenceKeys.LoggedInUserIdKey);
    var adiBookUser = await User(id: userId).getUser();
    if (adiBookUser.isVerified) {
      _defaultPage = HomePage();
    }
  }
  runApp(AdiBookApp(_defaultPage));
  Logger _logger = Logger('main method');
  _logger.info('Application launched successfully. This is a logger message');
}

Future _setupLogger() async {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord rec) async {
    var message = '${rec.level.name}: ${rec.time}: ${rec.message}';
    print(message);
    await _save(message);
  });
}

Future _save(String message) async {
  final directory = await getApplicationDocumentsDirectory();
  print(directory);
  final file = File('${directory.path}/my_file.txt');
  await file.writeAsString(message);
  print('saved');
}
