import 'package:adibook/app.dart';
import 'package:adibook/core/device_info.dart';
import 'package:adibook/core/log_manager.dart';
import 'package:adibook/core/page_manager.dart';
import 'package:adibook/data/user_manager.dart';
import 'package:adibook/pages/home_page.dart';
import 'package:adibook/pages/login_page.dart';
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
  var _userManager = UserManager();

  var adiBookUser = await _userManager.currentUser;
  _logger.info('FirebaseAuth.instance.currentUser() $adiBookUser');
  if (adiBookUser != null) {
    _logger.info(
        'Logged in user $adiBookUser, user name ${adiBookUser.name} as ${adiBookUser.userType}');
    _defaultPage = HomePage(
      userType: adiBookUser.userType,
      sectionType: PageManager().defaultSectionType(adiBookUser.userType),
    );
    await _userManager.updateAppDataByUser(adiBookUser);
  }
  runApp(AdiBookApp(_defaultPage));
  _logger.info(
      'Application launched successfully with default page set as ${_defaultPage.runtimeType.toString()}. This is a logger message');
}
