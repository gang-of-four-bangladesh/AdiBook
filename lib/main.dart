import 'package:adibook/app.dart';
import 'package:adibook/core/log_manager.dart';
import 'package:adibook/models/user.dart';
import 'package:adibook/pages/home_page.dart';
import 'package:adibook/pages/login_page.dart';
import 'package:adibook/utils/device_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';

Future main() async {
  await DeviceInfo.initializeDeviceState();
  var logWriter =
      DeviceInfo.isOnPhysicalDevice ? StorageLogWriter() : ConsoleLogWriter();
  await LoggerSetup.setupLogger(logWriter: logWriter);
  var _logger = Logger('main');
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  Widget _defaultPage = LoginPage();
  
  var currentUser = await FirebaseAuth.instance.currentUser();
  _logger.info('FirebaseAuth.instance.currentUser()? $currentUser');
  if (currentUser != null) {
    var adiBookUser = await User(id: currentUser.uid).getUser();
    _logger.info('Logged in user ${adiBookUser.name} as ${adiBookUser.userType}');
    _defaultPage = HomePage();//UserManager().landingPageOnUserType(adiBookUser.userType);
  }
  runApp(AdiBookApp(_defaultPage));
  _logger.info(
      'Application launched successfully with default page set as ${_defaultPage.runtimeType.toString()}. This is a logger message');
}
 