import 'package:flutter/material.dart';
import 'common_function.dart';

CommonClass commonClass = new CommonClass();
List<String> pupilActivityListFirst = [
  "Add a Lesson",
  "Progress Planner",
  "Lesson Card",
  "Report Card",
  "Payments",
  "Call",
  "Sent Message",
  "Details",
  "Reset Password",
  "Archive"
];
List<String> pupilActivityListSecond = [];

class PupilActivity extends StatelessWidget {
  PupilActivity({this.nam});
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
                child: ListTile(
                  title: 
                  //index == 4 ?SizedBox(height: 5,):null,
                  Text(pupilActivityListFirst[index]),
                  onTap: () {},
                ),
              );
            },
            //separatorBuilder: (BuildContext context, int index) => const Divider(),
          ),
        ));
  }
}
