import 'package:flutter/material.dart';

class PupilHomePage extends StatefulWidget {
  PupilHomePage({Key key}) : super(key: key);
  _PupilHomePageState createState() => _PupilHomePageState();
}

class _PupilHomePageState extends State<PupilHomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        'Pupil home page.',
        style: TextStyle(color: Colors.green, fontSize: 22),
      ),
    );
  }
}
