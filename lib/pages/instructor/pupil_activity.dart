import 'package:adibook/pages/instructor/add_lesson_section.dart';
import 'package:adibook/utils/common_function.dart';
import 'package:adibook/utils/constants.dart';
import 'package:flutter/material.dart';

List pupilActivityListFirst = [
  "Add a Lesson",
  "Progress Planner",
  "Lesson Card",
  "Report Card",
  "Payments",
  "",
  "Call",
  "Sent Message",
  "Details",
  "Reset Password",
  "Archive"
];

class PupilActivity extends StatefulWidget {
  PupilActivity({this.nam});
  final nam;

  @override
  _PupilActivityState createState() => _PupilActivityState();
}

class _PupilActivityState extends State<PupilActivity> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(CommonClass().hexColor('#03D1BF')),
        title: Text(widget.nam),
      ),
      body: Container(
        child: ListView.builder(
          itemCount: pupilActivityListFirst.length,
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 1.5, color: Colors.black12),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
              child: index == 5
                  ? ListTile(
                      title: Text(
                          widget.nam.toString().toUpperCase() + " PROFILE",
                          style: TextStyle(color: Colors.grey)),
                    )
                  : ListTile(
                      title: Text(pupilActivityListFirst[index]),
                      trailing: Icon(
                        Icons.keyboard_arrow_right,
                        color: Colors.black,
                      ),
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(PageRoutes.PupilActivityHome);
                      },
                    ),
            );
          },
        ),
      ),
    );
  }
}
