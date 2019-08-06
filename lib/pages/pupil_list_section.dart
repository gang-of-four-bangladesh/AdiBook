import 'package:adibook/models/instructor.dart';
import 'package:adibook/models/pupil.dart';
import 'package:adibook/pages/add_pupil_section.dart';
import 'package:adibook/pages/common_function.dart';
import 'package:adibook/pages/pupil_activity.dart';
import 'package:adibook/utils/constants.dart';
import 'package:adibook/utils/user_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/cupertino.dart';

CommonClass commonClass = new CommonClass();

class PupilListSection extends StatefulWidget {
  @override
  PupilPistSectionState createState() => PupilPistSectionState();
}

class PupilPistSectionState extends State<PupilListSection> {
  String instructorId;
  @override
  void initState() async {
    super.initState();
    this.instructorId = await UserManager.currentUserId;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Instructor(id: instructorId).getPupils().asStream(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Text('Loading...');
          default:
            return new ListView(
              children: snapshot.data.documents.map(
                (DocumentSnapshot document) {
                  return new ListTile(
                    trailing: Icon(Icons.person),
                    title: Text(document["nam"]),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              PupilActivity(nam: document["nam"]),
                        ),
                      );
                    },
                  );
                },
              ).toList(),
            );
        }
      },
    );
  }
}
