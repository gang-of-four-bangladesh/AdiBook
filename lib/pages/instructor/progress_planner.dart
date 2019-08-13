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
            child: Center(
                child: Checkbox(
              onChanged: (value) => {},
              value: false,
            )),
            height: 20.0,
            width: 40.0,
          ),
          SizedBox(
            child: Center(
                child: Checkbox(
              onChanged: (value) => {},
              value: false,
            )),
            height: 20.0,
            width: 40.0,
          )
        ],
      ),
    );
  }
}
