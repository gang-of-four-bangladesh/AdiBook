import 'package:adibook/core/app_data.dart';
import 'package:adibook/core/frequent_widgets.dart';
import 'package:adibook/core/formatter.dart';
import 'package:adibook/data/lesson_manager.dart';
import 'package:adibook/data/pupil_manager.dart';
import 'package:adibook/models/lesson.dart';
import 'package:adibook/pages/home_page.dart';
import 'package:adibook/pages/instructor/pupil_activities/add_lesson_section.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gradient_colors/flutter_gradient_colors.dart';
import 'package:logging/logging.dart';
import 'package:adibook/core/constants.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class LessonListSection extends StatefulWidget {
  @override
  LessonListSectionState createState() => LessonListSectionState();
}

class LessonListSectionState extends State<LessonListSection> {
  bool flagWarranty = false;
  Stream<QuerySnapshot> _querySnapshot;
  FrequentWidgets frequentWidgets = FrequentWidgets();
  Logger _logger = Logger('page->lesson_list');
  String _pupilId;

  @override
  void initState() {
    super.initState();
    _loadLessonsData();
  }

  void _loadLessonsData() async {
    this._pupilId = _getPupilId();
    if (!mounted) return;
    setState(() {
      _querySnapshot = PupilManager()
          .getLessions(
              instructorId: appData.instructor.id, pupilId: this._pupilId)
          .asStream();
    });
  }

  String _getPupilId() {
    if (isNotNullOrEmpty(appData.pupil)) return appData.pupil.id;
    if (appData.contextualInfo != null &&
        appData.contextualInfo.containsKey(DataSharingKeys.PupilIdKey))
      return appData.contextualInfo[DataSharingKeys.PupilIdKey].toString();
    return null;
  }

  @override
  Widget build(BuildContext context) {
    _logger.fine('Loading pupil lessons listing page.');
    return StreamBuilder<QuerySnapshot>(
      stream: _querySnapshot,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        var format = DateFormat("EE, MMM dd, yyyy @ hh:mm aaa");
        if (snapshot.connectionState == ConnectionState.waiting)
          return this.frequentWidgets.getProgressBar();
        if (snapshot.data == null) return FrequentWidgets().getProgressBar();
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');
        if (snapshot.data.docs.length == 0)
          return Card(
              child: Center(
                  child: Text(
            "No Lesson Found",
            style: TextStyle(fontWeight: FontWeight.bold),
          )));
        return ListView(
          children: snapshot.data.docs.map(
            (DocumentSnapshot document) {
              return appData.user.userType == UserType.Instructor
                  ? Slidable(
                      secondaryActions: <Widget>[],
                      actions: <Widget>[
                          IconSlideAction(
                            caption: 'Remove',
                            color: Colors.red,
                            icon: EvaIcons.trash,
                            onTap: () async {
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
                                        onPressed: () async {
                                          Navigator.of(context)
                                              .pop(ConfirmAction.ACCEPT);
                                          _deleteData(document.id);
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
                            icon: EvaIcons.edit,
                            onTap: () {
                              appData.contextualInfo = {
                                DataSharingKeys.LessonIdKey:
                                    document.id,
                                DataSharingKeys.PupilIdKey: this._pupilId
                              };
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HomePage(
                                    sectionType:
                                        SectionType.InstructorActivityForPupil,
                                    userType: UserType.Instructor,
                                    toDisplay: AddLessonSection(),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      actionPane: SlidableScrollActionPane(),
                      actionExtentRatio: 0.12,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
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
                              gradient:
                                  LinearGradient(colors: GradientColors.cloud)),
                          child: ListTile(
                            title: Container(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                children: <Widget>[
                                  //  Lesson Date,
                                  Container(
                                    padding:
                                        EdgeInsets.only(left: 2.0, right: 2.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          /*1*/
                                          child: Column(
                                            children: [
                                              /*2*/
                                              Container(
                                                child: Row(
                                                  children: <Widget>[
                                                    Column(
                                                      children: <Widget>[
                                                        Text(
                                                          enumValueToString((format
                                                                  .format(TypeConversion.timeStampToDateTime(
                                                                      document.get(
                                                                          Lesson
                                                                              .LessonDateKey)))
                                                                  .toString())) +
                                                              '\nDuration: ' +
                                                              document.get(Lesson
                                                                          .LessonDurationKey
                                                                      .toString() +
                                                                  ' minutes \n' +
                                                                  'Pickup: ' +
                                                                  enumValueToString(
                                                                      TripLocation
                                                                          .values[
                                                                              int.parse(document.get(Lesson.PickUpLocationKey.toString()))]
                                                                          .toString()) +
                                                                  '\nDrop Off: ') +
                                                              enumValueToString(
                                                                TripLocation
                                                                        .values[int.parse(document
                                                                            .get(Lesson.DropOffLocationKey)
                                                                            .toString())]
                                                                        .toString() +
                                                                    '\nLesson Type: ' +
                                                                    enumValueToString(
                                                                      LessonType
                                                                              .values[int.parse(document.get([Lesson.LessonTypeKey].toString()))]
                                                                              .toString() +
                                                                          '\nVehicle Type: ' +
                                                                          enumValueToString(
                                                                            VehicleType.values[int.parse(document.get([Lesson.VehicleTypeKey].toString()))].toString() +
                                                                                '\nNotes: ' +
                                                                                document.get([Lesson.DiaryNotesKey].toString()) +
                                                                                '\nReport: ' +
                                                                                document.get([Lesson.ReportCardKey].toString()),
                                                                          ),
                                                                    ),
                                                              ),
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 14,
                                                          ),
                                                          textAlign:
                                                              TextAlign.left,
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Checkbox(
                                              value: document.get([
                                                  Lesson.HasAcknowledgedKey]),
                                              onChanged: (check) {
                                                document.get([Lesson
                                                            .HasAcknowledgedKey]) ==
                                                        false
                                                    ? appData.user.userType ==
                                                            UserType.Pupil
                                                        ? _updateData(
                                                            document.id)
                                                        : Container()
                                                    : Container();
                                              },
                                              activeColor:
                                                  AppTheme.appThemeColor,
                                            ),
                                            Text(
                                              'Acknowledge',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ))
                  : Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
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
                            gradient:
                                LinearGradient(colors: GradientColors.cloud)),
                        child: ListTile(
                          title: Container(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: <Widget>[
                                //  Lesson Date,
                                Container(
                                  padding:
                                      EdgeInsets.only(left: 2.0, right: 2.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        /*1*/
                                        child: Column(
                                          children: [
                                            /*2*/
                                            Container(
                                              child: Row(
                                                children: <Widget>[
                                                  Column(
                                                    children: <Widget>[
                                                      Text(
                                                        enumValueToString((format
                                                                    .format(TypeConversion
                                                                        .timeStampToDateTime(document.get([Lesson
                                                                            .LessonDateKey])))
                                                                    .toString()) +
                                                                '\nDuration: ' +
                                                                document.get([Lesson
                                                                        .LessonDurationKey]
                                                                    .toString()) +
                                                                ' minutes \n' +
                                                                'Pickup: ' +
                                                                enumValueToString(TripLocation
                                                                    .values[int.parse(
                                                                        document.get([Lesson.PickUpLocationKey]
                                                                            .toString()))]
                                                                    .toString()) +
                                                                '\nDrop Off: ') +
                                                            enumValueToString(
                                                              TripLocation
                                                                      .values[int.parse(
                                                                          document.get([Lesson.DropOffLocationKey]
                                                                              .toString()))]
                                                                      .toString() +
                                                                  '\nLesson Type: ' +
                                                                  enumValueToString(
                                                                    LessonType
                                                                            .values[int.parse(document.get([Lesson.LessonTypeKey].toString()))]
                                                                            .toString() +
                                                                        '\nVehicle Type: ' +
                                                                        enumValueToString(
                                                                          VehicleType.values[int.parse(document.get([Lesson.VehicleTypeKey].toString()))].toString() +
                                                                              '\nNotes: ' +
                                                                              document.get([Lesson.DiaryNotesKey].toString()) +
                                                                              '\nReport: ' +
                                                                              document.get([Lesson.ReportCardKey].toString()),
                                                                        ),
                                                                  ),
                                                            ),
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14,
                                                        ),
                                                        textAlign:
                                                            TextAlign.left,
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Checkbox(
                                            value: document.get([
                                                Lesson.HasAcknowledgedKey]),
                                            onChanged: (check) {
                                              document.get([Lesson
                                                          .HasAcknowledgedKey]) ==
                                                      false
                                                  ? appData.user.userType ==
                                                          UserType.Pupil
                                                      ? _updateData(
                                                          document.id)
                                                      : Container()
                                                  : Container();
                                            },
                                            activeColor: AppTheme.appThemeColor,
                                          ),
                                          Text(
                                            'Acknowledge',
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
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

  String enumValueToString(String enumvalue) {
    return enumvalue
        .toString()
        .substring(enumvalue.toString().indexOf('.') + 1);
  }

  Future<void> _updateData(String lessonId) async {
    this._logger.info('Updating lesson information $lessonId.');
    Lesson lesson = await Lesson(
            pupilId: this._pupilId,
            instructorId: appData.instructor.id,
            id: lessonId)
        .getLession();
    lesson.hasAcknowledged = true;
    var result = await lesson.update();
    String message = isNotNullOrEmpty(result)
        ? 'Lesson updated successfully.'
        : 'Lesson update failed.';
    FrequentWidgets _frequentWidgets = FrequentWidgets();
    _frequentWidgets.getSnackbar(
      message: message,
      context: context,
    );
    _loadLessonsData();
  }

  Future<void> _deleteData(String lessonId) async {
    String message = isNotNullOrEmpty(await LessonManager().deleteLesson(
      instructorId: appData.instructor.id,
      pupilId: this._pupilId,
      lessonId: lessonId,
    ))
        ? 'Lesson deleted successfully.'
        : 'Lesson deleted failed.';
    frequentWidgets.getSnackbar(
      message: message,
      context: context,
    );
    this._loadLessonsData();
  }
}
