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
                              builder: (context) => AddPupilSection(
                                  userType: appData.user.userType),
                            ),
                          );
                        },
                      ),
                    ],
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Icon(Icons.person),
                      ),
                      title: Text(document[Pupil.NameKey]),
                      subtitle:
                          document[Pupil.PhoneNumberKey].toString() == null
                              ? Text(EmptyString)
                              : Text(document[Pupil.PhoneNumberKey].toString()),
                      onTap: () {
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
