import 'package:adibook/utils/common_function.dart';
import 'package:flutter/material.dart';

class MoreList extends StatefulWidget {
  @override
  _MoreListState createState() => _MoreListState();
}

class _MoreListState extends State<MoreList> {
  CommonClass commonClass = new CommonClass();
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
    Future<void> dialogBox(BuildContext context, String title, String message) {
      return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

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
              onTap: () {
                index == 7
                    ? dialogBox(context, 'No Update Available',
                        'Your version is up to date')
                    : null;
              },
            ),
          );
        },
        //separatorBuilder: (BuildContext context, int index) => const Divider(),
      ),
    );
  }
}
