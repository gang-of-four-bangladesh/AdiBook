import 'package:adibook/data/progress_plan_manager.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class ProgressPlannerSection extends StatefulWidget {
  ProgressPlannerSection({Key key}) : super(key: key);
  _ProgressPlannerSectionState createState() => _ProgressPlannerSectionState();
}

class _ProgressPlannerSectionState extends State<ProgressPlannerSection> {
  @override
  void initState() {
    super.initState();
  }

  double _rating = 0;

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
                  child: ListTile(
                    title: Text(
                      _progressPlans[index],
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SmoothStarRating(
                  allowHalfRating: false,
                  onRatingChanged: (v) {
                    setState(() {
                      _rating = v;
                      print('Rating changed for index $index to $_rating');
                    });
                  },
                  starCount: 5,
                  rating: _rating,
                  size: 35.0,
                  color: Colors.green,
                  borderColor: Colors.green,
                  spacing: 0.0,
                ),
                // RatingBar(
                //   initialRating: 5,
                //   direction: Axis.horizontal,
                //   itemCount: 5,
                //   itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                //   itemBuilder: (context, _) => Icon(
                //     Icons.star,
                //     color: Colors.amber,
                //   ),
                //   onRatingUpdate: (rating) {
                //     print(rating);
                //   },
                // ),
              ],
            ),
          );
        },
        //separatorBuilder: (BuildContext context, int index) => const Divider(),
      ),
    );
  }
}
