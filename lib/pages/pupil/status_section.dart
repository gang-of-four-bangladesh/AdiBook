import 'package:adibook/data/progress_plan_manager.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class StatusSection extends StatefulWidget {
  @override
  _StatusSectionState createState() => _StatusSectionState();
}

class _StatusSectionState extends State<StatusSection> {
  Logger _logger = Logger('pages->status');
  double _progressPercentage = 0;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  void _initialize() async {
    var _progress = await ProgressPlanManager().getProgressPercentage();
    this._logger.info('Progress percentage is $_progress');
    setState(() {
      this._progressPercentage = _progress;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CircularPercentIndicator(
      radius: 120.0,
      lineWidth: 13.0,
      animation: true,
      percent: this._progressPercentage,
      center: new Text(
        '$_progressPercentage %',
        style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
      ),
      footer: new Text(
        "Overall Progress",
        style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
      ),
      circularStrokeCap: CircularStrokeCap.round,
      progressColor: Colors.purple,
    );
  }
}
