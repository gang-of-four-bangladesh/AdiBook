import 'package:adibook/models/instructor.dart';
import 'package:adibook/models/pupil.dart';
import 'package:adibook/pages/common_function.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/cupertino.dart';

CommonClass commonClass = new CommonClass();

class PupilListSection extends StatefulWidget {
  @override
  PupilPistSectionState createState() => PupilPistSectionState();
}

class PupilPistSectionState extends State<PupilListSection> {
  List myList;
  ScrollController _scrollController = ScrollController();
  int _currentMax = 10;
  final _totallength = 50;
  @override
  void initState() {
    super.initState();
    myList = List.generate(10, (i) => "Item : ${i + 1}");
      
    _scrollController.addListener(() {
      if (myList.length >=_totallength) {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          _getMoreData();
        }
      }
    });
  }

  _getMoreData() {
    for (int i = _currentMax; i < _currentMax + 10; i++) {
      myList.add("Item : ${i + 1}");
    }
    _currentMax = _currentMax + 10;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        controller: _scrollController,
        itemExtent: 80,
        itemBuilder: (context, index) {
          // if(myList.length <= _totallength)
          // {
          if (index == myList.length) {
            return CupertinoActivityIndicator();
         // }
          }
          return Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 1.5, color: Colors.black12),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
            child: ListTile(
              title: Text('Pupil + $index'),
              onTap: () {},
            ),
          );
        },
        itemCount: myList.length + 1,
        //separatorBuilder: (BuildContext context, int index) => const Divider(),
      ),
    );
  }
}
