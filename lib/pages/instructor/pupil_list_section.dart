import 'package:adibook/core/app_data.dart';
import 'package:adibook/core/constants.dart';
import 'package:adibook/core/frequent_widgets.dart';
import 'package:adibook/models/instructor.dart';
import 'package:adibook/models/pupil.dart';
import 'package:adibook/pages/home_page.dart';
import 'package:adibook/pages/instructor/add_pupil_section.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:logging/logging.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class PupilListSection extends StatefulWidget {
  @override
  PupilPistSectionState createState() => PupilPistSectionState();
}

class PupilPistSectionState extends State<PupilListSection> {
  Stream<QuerySnapshot> _querySnapshot;
  FrequentWidgets frequentWidgets = FrequentWidgets();
  Logger _logger = Logger('page->pupil_list');

  @override
  void initState() {
    super.initState();
    _loadPupilsData();
  }

  void _loadPupilsData() async {
    if (mounted) {
      setState(() {
        _querySnapshot =
            Instructor(id: appData.instructorId).getPupils().asStream();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _logger.fine('Loading pupils listing page.');
    return StreamBuilder<QuerySnapshot>(
      stream: _querySnapshot,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.data == null) return FrequentWidgets().getProgressBar();
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return this.frequentWidgets.getProgressBar();
          default:
            return ListView(
              children: snapshot.data.documents.map(
                (DocumentSnapshot document) {
                  return Slidable(
                    actionPane: SlidableStrechActionPane(),
                    actionExtentRatio: 0.15,
                    actions: <Widget>[
                      IconSlideAction(
                        caption: 'Delete',
                        color: Colors.red,
                        icon: FontAwesomeIcons.trash,
                        onTap: () {},
                      ),
                      IconSlideAction(
                        caption: 'Edit',
                        color: AppTheme.appThemeColor,
                        icon: FontAwesomeIcons.edit,
                        foregroundColor: Colors.white,
                        onTap: () {
                          appData.pupilId = document.documentID;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AddPupilSection(userType: appData.userType),
                            ),
                          );
                        },
                      ),
                    ],
                    child: ListTile(
                      trailing: Icon(Icons.person),
                      title: Text(document[Pupil.NameKey]),
                      onTap: () {
                        appData.pupilId = document.documentID;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomePage(
                              sectionType:
                                  SectionType.InstructorActivityForPupil,
                              userType: UserType.Instructor,
                              contextInfo: {
                                DataSharingKeys.PupilIdKey: document.documentID
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ).toList(),
            );
        }
      },
    );
  }
}
