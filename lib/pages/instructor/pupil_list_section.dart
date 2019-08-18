import 'package:adibook/core/app_data.dart';
import 'package:adibook/data/user_manager.dart';
import 'package:adibook/models/instructor.dart';
import 'package:adibook/models/pupil.dart';
import 'package:adibook/pages/home_page.dart';
import 'package:adibook/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:logging/logging.dart';

class PupilListSection extends StatefulWidget {
  @override
  PupilPistSectionState createState() => PupilPistSectionState();
}

class PupilPistSectionState extends State<PupilListSection> {
  Stream<QuerySnapshot> _querySnapshot;
  @override
  void initState() {
    super.initState();
    _loadPupilsData();
  }

  void _loadPupilsData() async {
    setState(() {
      _querySnapshot = Instructor(id: appData.instructorId).getPupils().asStream();
    });
  }

  @override
  Widget build(BuildContext context) {
    Logger _logger = Logger(this.runtimeType.toString());
    _logger.fine('Loading pupils listing page.');
    return StreamBuilder<QuerySnapshot>(
      stream: _querySnapshot,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.data == null) return Text('Please wait..');
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Text('Loading...');
          default:
            return ListView(
              children: snapshot.data.documents.map(
                (DocumentSnapshot document) {
                  return ListTile(
                    trailing: Icon(Icons.person),
                    title: Text(document["nam"]),
                    onTap: () {
                      appData.pupilId = document.documentID;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePage(
                            sectionType: SectionType.InstructorActivityForPupil,
                            userType: UserType.Instructor,
                            contextInfo: {
                              DataSharingKeys.PupilIdKey: document.documentID
                            },
                          ),
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
