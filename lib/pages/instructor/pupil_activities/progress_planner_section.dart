import 'package:adibook/data/progress_plan_manager.dart';
import 'package:flutter/material.dart';

class ProgressPlannerSection extends StatefulWidget {
  ProgressPlannerSection({Key key}) : super(key: key);
  _ProgressPlannerSectionState createState() => _ProgressPlannerSectionState();
}

class _ProgressPlannerSectionState extends State<ProgressPlannerSection> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _progressPlans = ProgressPlanManager.defaultProjectPlans.values.toList();
    return Container(
      child: ListView.builder(
        itemCount: _progressPlans.length,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 1.5, color: Colors.black12),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
            child: ListTile(
              title: Text(_progressPlans[index]),
              onTap: () {

              },
            ),
          );
        },
        //separatorBuilder: (BuildContext context, int index) => const Divider(),
      ),
    );
  }
}
