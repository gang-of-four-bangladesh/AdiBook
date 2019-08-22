import 'package:adibook/core/app_data.dart';
import 'package:adibook/data/pupil_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:logging/logging.dart';
import 'package:adibook/core/constants.dart';
import 'package:adibook/utils/common_function.dart';

class LessonListSection extends StatefulWidget {
  @override
  LessonListSectionState createState() => LessonListSectionState();
}

class LessonListSectionState extends State<LessonListSection> {
  CommonClass commonClass = new CommonClass();
  Stream<QuerySnapshot> _querySnapshot;
  @override
  void initState() {
    super.initState();
    _loadLessonsData();
  }

  void _loadLessonsData() async {
    setState(() {
      print(
          'Lesson listing instructor id ${appData.instructorId}, pupil id ${appData.pupilId}');
      _querySnapshot = PupilManager()
          .getLessions(
              instructorId: appData.instructorId, pupilId: appData.pupilId)
          .asStream();
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
                  return Container(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          commonClass.convertTimeStampToStringDate(
                              document["ldt"].toString(),
                              'EEEE dd MMMM @ HH:mm'),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          enumValueToString(LessionType
                                  .values[int.parse(document["ltp"].toString())]
                                  .toString() +
                              ' - ' +
                              document["ldu"].toString() +
                              ' minutes - ' +
                              enumValueToString(VehicleType
                                  .values[int.parse(document["vtp"].toString())]
                                  .toString()) +
                              " Drive"),
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                            enumValueToString(TripLocation.values[
                                        int.parse(document["pul"].toString())]
                                    .toString()) +
                                ' : ' +
                                enumValueToString(TripLocation.values[
                                        int.parse(document["dol"].toString())]
                                    .toString()),
                            style: TextStyle(fontSize: 16)),
                        SizedBox(
                          height: 5,
                        ),
                        Text(document["dnt"].toString(),
                            style: TextStyle(fontSize: 14)),
                      ],
                    ),
                  );
                },
              ).toList(),
            );
        }
      },
    );
  }

  String enumValueToString(String enumvalue) {
    return enumvalue
        .toString()
        .substring(enumvalue.toString().indexOf('.') + 1);
  }
}
