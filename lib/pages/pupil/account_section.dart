import 'package:flutter/material.dart';

List pupilActivityListFirst = [
  "Driving Profile",
  "Account Details",
  "Log Out",
  "Recommend a Friend",
  "Terms and Conditions",
  "GDRP Policy",
  "Switch Driving School"
];

class AccountSection extends StatefulWidget {
  @override
  _AccountSectionState createState() => _AccountSectionState();
}

class _AccountSectionState extends State<AccountSection> {
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
        ));
  }
}
