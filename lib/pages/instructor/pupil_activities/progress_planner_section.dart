import 'package:adibook/core/app_data.dart';
import 'package:adibook/core/constants.dart';
import 'package:adibook/data/progress_plan_manager.dart';
import 'package:adibook/models/progress_plan.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class ProgressPlannerSection extends StatefulWidget {
  ProgressPlannerSection({Key key}) : super(key: key);
  _ProgressPlannerSectionState createState() => _ProgressPlannerSectionState();
}

class _ProgressPlannerSectionState extends State<ProgressPlannerSection> {
  Logger _logger = Logger('progress_planner');
  List<ProgressPlanViewModel> _progressPlanDetails = [];
  String _pupilId;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  void _initialize() async {
    _logger.info('initalizing progress planner. Loading planning list.');
    this._pupilId = this._getPupilId();
    var instructorId = appData.instructor.id;
    var _progressDetails = await ProgressPlanManager()
        .getProgressDetails(pupilId: this._pupilId, instructorId: instructorId);
    setState(() {
      this._progressPlanDetails = _progressDetails;
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
    return Container(
        child: Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.green,
              width: 1.0,
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.circular(12.0),
            color: Colors.grey.withOpacity(0.3),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.star,
                        size: 20.0,
                        color: Colors.green,
                      ),
                      SizedBox(
                        width: 2.0,
                      ),
                      Text(
                        "Introduced",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.star,
                        size: 20.0,
                        color: Colors.green,
                      ),
                      Icon(
                        Icons.star,
                        size: 20.0,
                        color: Colors.green,
                      ),
                      SizedBox(
                        width: 2.0,
                      ),
                      Text(
                        "Prompted",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.star,
                        size: 20.0,
                        color: Colors.green,
                      ),
                      Icon(
                        Icons.star,
                        size: 20.0,
                        color: Colors.green,
                      ),
                      Icon(
                        Icons.star,
                        size: 20.0,
                        color: Colors.green,
                      ),
                      SizedBox(
                        width: 2.0,
                      ),
                      Text(
                        "Rarely Prompted",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.star,
                        size: 20.0,
                        color: Colors.green,
                      ),
                      Icon(
                        Icons.star,
                        size: 20.0,
                        color: Colors.green,
                      ),
                      Icon(
                        Icons.star,
                        size: 20.0,
                        color: Colors.green,
                      ),
                      Icon(
                        Icons.star,
                        size: 20.0,
                        color: Colors.green,
                      ),
                      SizedBox(
                        width: 2.0,
                      ),
                      Text(
                        "Independent",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          height: 4.0,
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _progressPlanDetails.length,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 1.5, color: Colors.black12),
                  ),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        title: Text(
                          _progressPlanDetails[index].subjectDisplayName,
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SmoothStarRating(
                      allowHalfRating: false,
                      onRatingChanged: (v) async {
                        setState(() {
                          _progressPlanDetails[index].status =
                              ProgressSubjectStatus.values[v.toInt()];
                          print(
                              'Rating changed for index ${_progressPlanDetails[index].subjectDisplayName} from $v to ${_progressPlanDetails[index].status}');
                        });
                        var _subject = new ProgressPlanSubject(
                          subjectName: _progressPlanDetails[index].subjectName,
                          subjectStatus:
                              ProgressSubjectStatus.values[v.toInt()],
                        );
                        await ProgressPlan(
                          pupilId: this._pupilId,
                          instructorId: appData.instructor.id,
                          progressPlanSubject: _subject,
                        ).update();
                      },
                      starCount: 4,
                      rating:
                          _progressPlanDetails[index].status.index.toDouble(),
                      size: 35.0,
                      color: Colors.green,
                      borderColor: Colors.green,
                      spacing: 0.0,
                    ),
                  ],
                ),
              );
            },
            //separatorBuilder: (BuildContext context, int index) => const Divider(),
          ),
        )
      ],
    ));
  }
}
