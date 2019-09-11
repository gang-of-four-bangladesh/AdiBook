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
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class LessonListSection extends StatefulWidget {
  @override
  LessonListSectionState createState() => LessonListSectionState();
}

class LessonListSectionState extends State<LessonListSection> {
  Stream<QuerySnapshot> _querySnapshot;
  FrequentWidgets frequentWidgets = FrequentWidgets();
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

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _loadLessonsData();
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    Logger _logger = Logger(this.runtimeType.toString());
    _logger.fine('Loading pupil lessons listing page.');
    return StreamBuilder<QuerySnapshot>(
      stream: _querySnapshot,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        var format = DateFormat("EEEE dd MMMM @ HH:mm aaa");
        if (snapshot.data == null) return FrequentWidgets().getProgressBar();
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return FrequentWidgets().getProgressBar();
          default:
            return SmartRefresher(
                controller: _refreshController,
                onRefresh: _onRefresh,
                child: ListView(
                  children: snapshot.data.documents.map(
                    (DocumentSnapshot document) {
                      return Slidable(
                         actionPane: SlidableScrollActionPane(),
                        actionExtentRatio: 0.12,
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
                            onTap: () {},
                          ),
                        ],
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              (format
                                  .format(TypeConversion.timeStampToDateTime(
                                      document["ldt"]))
                                  .toString()),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              enumValueToString(LessionType.values[
                                          int.parse(document["ltp"].toString())]
                                      .toString() +
                                  ' - ' +
                                  document["ldu"].toString() +
                                  ' minutes - ' +
                                  enumValueToString(VehicleType.values[
                                          int.parse(document["vtp"].toString())]
                                      .toString()) +
                                  " Drive"),
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                                enumValueToString(TripLocation.values[int.parse(
                                            document["pul"].toString())]
                                        .toString()) +
                                    ' : ' +
                                    enumValueToString(TripLocation.values[
                                            int.parse(
                                                document["dol"].toString())]
                                        .toString()),
                                style: TextStyle(fontSize: 16)),
                            SizedBox(
                              height: 1,
                            ),
                            Text(document["dnt"].toString(),
                                style: TextStyle(fontSize: 14)),
                          ],
                        ),
                      )
                      );
                    },
                  ).toList(),
                ));
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
