import 'package:adibook/app.dart';
import 'package:adibook/models/user.dart';
import 'package:adibook/pages/home_page.dart';
import 'package:adibook/pages/login_page.dart';
import 'package:adibook/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

Future main() async {
  Logger _logger = Logger('main method');
  await _setupLogger();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  Widget _defaultPage = LoginPage();

  var currentUser = await FirebaseAuth.instance.currentUser();
  _logger.info('FirebaseAuth.instance.currentUser()? $currentUser');
  if (currentUser != null) {
    _logger.info('Logged in user $currentUser');
    _defaultPage = HomePage();
  }
  runApp(AdiBookApp(_defaultPage));
  _logger.info(
      'Application launched successfully with default page set as ${_defaultPage.runtimeType.toString()}. This is a logger message');
}

Future _setupLogger() async {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord rec) async {
    var message = '${rec.level.name}: ${rec.time}: ${rec.message}';
    print(message);
    await _save(message);
  });
}

StringBuffer _stringBuffer = StringBuffer();
Future _save(String message) async {
  _stringBuffer.writeln(message);
  final directory = await getApplicationDocumentsDirectory();
  print(directory);
  var fileName =
      "${DateFormat('yyyyMMddH').format(DateTime.now().toUtc())}_log.txt";
  var filePath = '${directory.path}/$fileName';
  final file = File(filePath);
  await file.writeAsString(_stringBuffer.toString());
  final StorageReference storageRef =
      FirebaseStorage.instance.ref().child('/logs').child(fileName);
  storageRef.putFile(
    File(filePath),
    StorageMetadata(
      contentType: 'text/plain',
    ),
  );
}
