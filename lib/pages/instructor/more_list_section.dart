import 'package:flutter/material.dart';

class MoreList extends StatefulWidget {
  @override
  _MoreListState createState() => _MoreListState();
}

class _MoreListState extends State<MoreList> {
  @override
  Widget build(BuildContext context) {
    final moretabList = [
      'Finance',
      'Mileage',
      'Driving Tests',
      'Diary Setup',
      'Message All Your Pupils',
      'Internal Instructor Chat',
      'Pupil Achieves',
      'App Version 0.0',
    ];

    return Container(
      child: ListView.builder(
        itemCount: moretabList.length,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 1.5, color: Colors.black12),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
            child: ListTile(
              title: Text(moretabList[index]),
            ),
          );
        },
        //separatorBuilder: (BuildContext context, int index) => const Divider(),
      ),
    );
  }
}
