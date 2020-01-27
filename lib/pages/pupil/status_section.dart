import 'package:adibook/core/app_data.dart';
import 'package:adibook/core/constants.dart';
import 'package:adibook/data/progress_plan_manager.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class StatusSection extends StatefulWidget {
  @override
  _StatusSectionState createState() => _StatusSectionState();
}

class _StatusSectionState extends State<StatusSection> {
  double _progressPercentage = 0;
  List<ProgressPlanViewModel> _progressPlanDetails = [];

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  void _initialize() async {
    var _progressDetails = await ProgressPlanManager().getProgressDetails(
        pupilId: appData.pupil.id, instructorId: appData.instructor.id);
    var _progress = await ProgressPlanManager().getProgressPercentage(_progressDetails);
    if (!mounted) return;
    setState(() {
      this._progressPercentage = _progress;
      this._progressPlanDetails = _progressDetails;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CircularPercentIndicator(
          radius: 80.0,
          lineWidth: 10.0,
          animation: true,
          percent: this._progressPercentage,
          center: Text(
            '${(_progressPercentage * 100).ceil()}%',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
          footer: Text(
            "Driving Progress",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17.0,
            ),
          ),
          circularStrokeCap: CircularStrokeCap.round,
          progressColor: AppTheme.appThemeColor,
        ),
        Container(
          child: Text(
            'Your Progress report',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
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
                    Text(
                      _progressPlanDetails[index].status.index.toString(),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(width: 10),
                  ],
                ),
              );
            },
            //separatorBuilder: (BuildContext context, int index) => const Divider(),
          ),
        )
      ],
    );
  }
}
