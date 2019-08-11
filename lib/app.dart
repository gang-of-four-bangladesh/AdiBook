import 'package:adibook/pages/instructor_home_page.dart';
import 'package:adibook/pages/image_upload.dart';
import 'package:adibook/pages/login_page.dart';
import 'package:adibook/pages/pupil_activity.dart';
import 'package:adibook/pages/pupil_home_page.dart';
import 'package:adibook/pages/pupil_registration.dart';
import 'package:adibook/utils/constants.dart';
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
        PageRoutes.HomePage: (BuildContext context) => InstructorHomePage(),
        PageRoutes.PupilRegistrationPage: (BuildContext context) =>
            PupilRegistration(),
        PageRoutes.ImageUploadPage: (BuildContext context) => ImageUpload(),
        PageRoutes.PupilActivity: (BuildContext context) => PupilActivity(),
        PageRoutes.PupilHomePage: (BuildContext context) => PupilHomePage(),
      },
    );
  }
}
