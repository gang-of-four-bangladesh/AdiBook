import 'package:adibook/core/constants.dart';
import 'package:adibook/pages/home_page.dart';
import 'package:adibook/pages/instructor/image_upload.dart';
import 'package:adibook/pages/login_page.dart';
import 'package:adibook/pages/pupil/pupil_registration.dart';
import 'package:flutter/material.dart';

class AdiBookApp extends StatelessWidget {
  final Widget defaultPage;
  AdiBookApp(this.defaultPage);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: defaultPage,
      routes: <String, WidgetBuilder>{
        PageRoutes.LoginPage: (BuildContext context) => LoginPage(),
        PageRoutes.HomePage: (BuildContext context) => HomePage(),
        PageRoutes.PupilRegistrationPage: (BuildContext context) =>
            PupilRegistration(),
        PageRoutes.ImageUploadPage: (BuildContext context) => ImageUpload()
      },
    );
  }
}
