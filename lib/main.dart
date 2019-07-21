import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'pages/home_page.dart';
import 'pages/image_upload.dart';
import 'pages/login.dart';
import 'pages/login_page.dart';
import 'pages/pupil_registration.dart';

Future main() async {
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: LoginPage(),
    routes: <String, WidgetBuilder>{
      '/login': (BuildContext context) => new Login(),
      '/home': (BuildContext context) => new HomePage(),
      '/pupil_registration': (BuildContext context) => new PupilRegistration(),
      '/Image_upload': (BuildContext context) => new ImageUpload(),
    },
  ));
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Welcome to AdiBook', home: HomePage());
  }
}
