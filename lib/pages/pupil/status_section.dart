import 'package:adibook/data/progress_plan_manager.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class StatusSection extends StatefulWidget {
  @override
  _StatusSectionState createState() => _StatusSectionState();
}

class _StatusSectionState extends State<StatusSection> {
  double _progressPercentage = 0;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  void _initialize() async {
    var _progress = await ProgressPlanManager().getProgressPercentage();
    if (!mounted) return;
    setState(() {
      this._progressPercentage = _progress;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CircularPercentIndicator(
      radius: 120.0,
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
      progressColor: Colors.purple,
    );
  }
}
