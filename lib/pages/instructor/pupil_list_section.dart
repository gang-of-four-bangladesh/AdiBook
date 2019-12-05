import 'package:adibook/core/app_data.dart';
import 'package:adibook/core/constants.dart';
import 'package:adibook/core/frequent_widgets.dart';
import 'package:adibook/models/instructor.dart';
import 'package:adibook/models/pupil.dart';
import 'package:adibook/pages/home_page.dart';
import 'package:adibook/pages/instructor/add_pupil_section.dart';
import 'package:adibook/pages/instructor/pupil_activities/lesson_list_section.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:logging/logging.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

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
    if (!mounted) return;
    setState(() {
      _querySnapshot =
          Instructor(id: appData.instructor.id).getPupils().asStream();
    });
  }

  @override
  Widget build(BuildContext context) {
    _logger.fine('Loading pupils listing page.');
    return StreamBuilder<QuerySnapshot>(
      stream: _querySnapshot,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return this.frequentWidgets.getProgressBar();
        if (snapshot.data == null) return FrequentWidgets().getProgressBar();
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');
        if (snapshot.data.documents.length == 0)
          return Card(
              child: Center(
                  child: Text(
            "No Pupil Found",
            style: TextStyle(fontWeight: FontWeight.bold),
          )));
        return ListView(
          children: snapshot.data.documents.map(
            (DocumentSnapshot document) {
              return Slidable(
                actionPane: SlidableStrechActionPane(),
                actionExtentRatio: 0.15,
                actions: <Widget>[
                  IconSlideAction(
                    caption: 'Remove',
                    color: AppTheme.appThemeColor,
                    icon: FontAwesomeIcons.trash,
                    onTap: () {
                      showDialog<ConfirmAction>(
                        context: context,
                        barrierDismissible:
                            false, // user must tap button for close dialog!
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Delete"),
                            content: Text("Do you want to delete ?"),
                            actions: <Widget>[
                              FlatButton(
                                child: const Text('CANCEL'),
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(ConfirmAction.CANCEL);
                                },
                              ),
                              FlatButton(
                                child: const Text('ACCEPT'),
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(ConfirmAction.ACCEPT);
                                  _deleteData(document.documentID);
                                },
                              )
                            ],
                          );
                        },
                      );
                    },
                  ),
                  IconSlideAction(
                    caption: 'Edit',
                    color: AppTheme.appThemeColor,
                    icon: FontAwesomeIcons.edit,
                    foregroundColor: Colors.white,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              AddPupilSection(userType: appData.user.userType),
                        ),
                      );
                    },
                  ),
                ],
                child: Container(
                    child: 
                    ListTile(
                      //contentPadding: EdgeInsets.only(left: 0),
                      leading: CircleAvatar(
                        radius: 42,
                        child: Container(
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 42,
                          ),
                        ),
                        backgroundColor: AppTheme.appThemeColor,

                      ),
                      contentPadding: EdgeInsets.only(left: 0,right: 10),
                      title: Text(
                        document[Pupil.NameKey],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text("Phone Number"),                          
                      trailing: Text(DateFormat('dd/mm/yyyy').format(DateTime.now())),
                      onTap: () {
                        appData.contextualInfo = {
                          DataSharingKeys.PupilIdKey: document.documentID
                        };
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomePage(
                              sectionType:
                                  SectionType.InstructorActivityForPupil,
                              userType: UserType.Instructor,
                              toDisplay: LessonListSection(),
                            ),
                          ),
                        );
                      },
                    ),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: AppTheme.appThemeColor)),
                    
                  ),
                )
              );
            },
          ).toList(),
        );
      },
    );
  }

  Future<void> _deleteData(String pupilId) async {
    Pupil pupil = Pupil(id: pupilId);
    String message = isNotNullOrEmpty(await pupil.delete())
        ? 'Payment deleted successfully.'
        : 'Payment deleted failed.';
    FrequentWidgets _frequentWidgets = FrequentWidgets();
    _frequentWidgets.getSnackbar(
      message: message,
      context: context,
    );
    this._loadPupilsData();
  }
}
