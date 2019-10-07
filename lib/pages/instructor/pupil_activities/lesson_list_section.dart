import 'package:adibook/core/app_data.dart';
import 'package:adibook/core/frequent_widgets.dart';
import 'package:adibook/core/type_conversion.dart';
import 'package:adibook/data/pupil_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  bool _switchAckTest = false;
  @override
  void initState() {
    super.initState();
    _loadLessonsData();
  }

  void _loadLessonsData() async {
    if (!mounted) return;
    setState(() {
      this._switchAckTest = false;
      this._logger.info(
          'Lesson listing instructor id ${appData.instructorId}, pupil id ${appData.pupilId}');
      _querySnapshot = PupilManager()
          .getLessions(
              instructorId: appData.instructorId, pupilId: appData.pupilId)
          .asStream();
    });
  }

  @override
  Widget build(BuildContext context) {
    _logger.fine('Loading pupil lessons listing page.');
    return StreamBuilder<QuerySnapshot>(
      stream: _querySnapshot,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        var format = DateFormat("EEEE dd MMMM @ HH:mm aaa");
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');
        if (snapshot.data == null) return FrequentWidgets().getProgressBar();
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return FrequentWidgets().getProgressBar();
          default:
            return ListView(
              children: snapshot.data.documents.map(
                (DocumentSnapshot document) {
                  // this._switchAckTest =
                  //    document['ack'].toString() == 'true' ? true : false;
                  return Slidable(
                    actionPane: SlidableScrollActionPane(),
                    actionExtentRatio: 0.12,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: <Widget>[
                          //  Lesson Date,
                          Container(
                            padding: EdgeInsets.only(left: 2.0, right: 2.0),
                            child: Row(
                              children: [
                                Expanded(
                                  /*1*/
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      /*2*/
                                      Container(
                                        child: Row(
                                          children: <Widget>[
                                            Column(
                                              children: <Widget>[
                                                Text(
                                                  (format
                                                      .format(TypeConversion
                                                          .timeStampToDateTime(
                                                              document["ldt"]))
                                                      .toString()),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  enumValueToString(LessionType
                                                          .values[int.parse(
                                                              document["ltp"]
                                                                  .toString())]
                                                          .toString() +
                                                      ' - ' +
                                                      document["ldu"]
                                                          .toString() +
                                                      ' minutes - ' +
                                                      enumValueToString(VehicleType
                                                          .values[int.parse(
                                                              document["vtp"]
                                                                  .toString())]
                                                          .toString()) +
                                                      " Drive"),
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                    enumValueToString(TripLocation
                                                            .values[int.parse(
                                                                document["pul"]
                                                                    .toString())]
                                                            .toString()) +
                                                        ' : ' +
                                                        enumValueToString(TripLocation
                                                            .values[int.parse(
                                                                document["dol"]
                                                                    .toString())]
                                                            .toString()),
                                                    style: TextStyle(
                                                        fontSize: 16)),
                                                SizedBox(
                                                  height: 1,
                                                ),
                                              ],
                                            ),
                                            Text(document["dnt"].toString(),
                                                style: TextStyle(fontSize: 14)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                //Text(document["ack"].toString()),
                                Checkbox(
                                    value: _switchAckTest,
                                    onChanged: (bool val) => setState(() =>
                                        appData.userType == UserType.Instructor
                                            ? _switchAckTest = val
                                            : print(_switchAckTest)),
                                    activeColor: AppTheme.appThemeColor),
                              ],
                            ),
                          ),
                        ],
                      ),
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
