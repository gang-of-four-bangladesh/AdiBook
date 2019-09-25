import 'package:flutter/material.dart';

List pupilActivityListFirst = [
  "My Lessons List",
];

class StatusSection extends StatefulWidget {
  @override
  _StatusSectionState createState() => _StatusSectionState();
}

class _StatusSectionState extends State<StatusSection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                title: Text(pupilActivityListFirst[index]),
                trailing: Icon(
                  Icons.keyboard_arrow_right,
                  color: Colors.black,
                ),
                onTap: () {
                  // Navigator.of(context)
                  //     .pushNamed(PageRoutes.ProgressPlannerPage);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
