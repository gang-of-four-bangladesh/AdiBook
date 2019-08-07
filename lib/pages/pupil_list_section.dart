import 'package:adibook/models/instructor.dart';
import 'package:adibook/pages/pupil_activity.dart';
import 'package:adibook/utils/user_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

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
    var instructorId = await UserManager.currentUserId;
    setState(() {
      _querySnapshot = Instructor(id: instructorId).getPupils().asStream();
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _querySnapshot,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.data == null) return new Text('Please wait..');
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
