import 'package:adibook/core/app_data.dart';
import 'package:adibook/core/constants.dart';
import 'package:adibook/core/frequent_widgets.dart';
import 'package:adibook/models/instructor.dart';
import 'package:adibook/models/pupil.dart';
import 'package:adibook/pages/home_page.dart';
import 'package:adibook/pages/instructor/pupil_activities/lesson_list_section.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gradient_colors/flutter_gradient_colors.dart';
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
              return Container(
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),),
                    // color: Colors.tealAccent[100],
                    child: Container(
                      decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 5.0,
                                color: Colors.black.withOpacity(.1),
                                offset: Offset(6.0, 7.0),
                              )
                            ],
                            borderRadius: BorderRadius.circular(5),
                            gradient: LinearGradient(colors: GradientColors.cloud)),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 33,
                          child: Container(
                            child: Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 42,
                            ),
                          ),
                          backgroundColor: AppTheme.appThemeColor,
                        ),
                        contentPadding: EdgeInsets.all(5),
                        title: Text(
                          document[Pupil.NameKey],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(document.documentID),
                                  Text(DateFormat('MMM dd, yyyy')
                                      .format(DateTime.now())),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              // Container(
                              //   color: Colors.grey[300],
                              //   height: .5,
                              // ),
                            ],
                          ),
                        ),
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
                        trailing: IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.black,
                          ),
                          onPressed: () {
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
                      ),
                    ),
                  ),
                );
            },
          ).toList(),
        );
      },
    );
  }

  Future<void> _deleteData(String pupilId) async {
    Pupil pupil = Pupil(id: pupilId);
    String message = isNotNullOrEmpty(await pupil.delete(pupilId))
        ? 'Pupil deleted successfully.'
        : 'Pupil deleted failed.';
    if (pupil.id != null)
      await pupil.deleteOfAnInstructor(pupilId, appData.instructor.id);
    FrequentWidgets _frequentWidgets = FrequentWidgets();
    _frequentWidgets.getSnackbar(
      message: message,
      context: context,
    );
    this._loadPupilsData();
  }
}
