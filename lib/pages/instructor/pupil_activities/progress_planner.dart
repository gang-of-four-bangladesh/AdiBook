import 'package:flutter/material.dart';

class ProgressPlanner extends StatefulWidget {
  ProgressPlanner({Key key}) : super(key: key);
  _ProgressPlannerState createState() => _ProgressPlannerState();
}

class _ProgressPlannerState extends State<ProgressPlanner> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          SizedBox(
            child: Text('Subject'),
            height: 50.0,
            width: 100.0,
          ),
          SizedBox(
            child: Text('Introduced'),
            height: 50.0,
            width: 50.0,
          ),
          SizedBox(
            child: Text('Talk Through'),
            height: 50.0,
            width: 50.0,
          ),
          SizedBox(
            child: Text('Prompted'),
            height: 50.0,
            width: 50.0,
          ),
          SizedBox(
            child: Text('Rarely Prompted'),
            height: 50.0,
            width: 50.0,
          ),
          SizedBox(
            child: Text('Independent'),
            height: 50.0,
            width: 50.0,
          )
        ],
      ),
    );
  }
}
