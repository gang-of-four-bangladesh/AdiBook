import 'package:adibook/data/progress_plan_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

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
    var _progressPlans =
        ProgressPlanManager.defaultProjectPlans.values.toList();
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
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: Text(_progressPlans[index]),
                      )
                    ],
                  ),
                ),
                Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                SizedBox(width: 10),
              ],
            ),
          );
        },
        //separatorBuilder: (BuildContext context, int index) => const Divider(),
      ),
    );
  }
}
