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

class PupilActivity extends StatelessWidget {
  PupilActivity({this.nam});
  CommonClass commonClass = new CommonClass();
  final nam;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Color(commonClass.hexColor('#03D1BF')),
          title: Text(nam),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
                child: index == 5
                    ? ListTile(
                        title: Text(nam.toString().toUpperCase() + " PROFILE",
                            style: TextStyle(color: Colors.grey)),
                      )
                    : ListTile(
                        title: Text(pupilActivityListFirst[index]),
                        trailing: Icon(
                          Icons.keyboard_arrow_right,
                          color: Colors.grey[300],
                        ),
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(PageRoutes.ProgressPlannerPage);
                        },
                      ),
              );
            },
          ),
        ));
  }
}
