import 'package:adibook/models/instructor.dart';
import 'package:adibook/pages/pupil_activity.dart';
import 'package:adibook/utils/user_manager.dart';
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
    var instructorId = await UserManager.currentUserId;
    setState(() {
      _querySnapshot = Instructor(id: instructorId).getPupils().asStream();
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
