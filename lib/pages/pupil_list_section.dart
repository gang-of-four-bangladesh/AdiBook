import 'package:adibook/models/instructor.dart';
import 'package:adibook/models/pupil.dart';
import 'package:adibook/pages/common_function.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

CommonClass commonClass = new CommonClass();
class PupilListSection extends StatefulWidget {
  @override
  PupilPistSectionState createState() => PupilPistSectionState();
}

class PupilPistSectionState extends State<PupilListSection> {
  @override
  Widget build(BuildContext context) {
    new Instructor().get().then((instructor) {
      var id = new Uuid().v1();
       new Pupil(id: id).add();
    });
    return Container(
      child: ListView.builder(
        itemCount: 16,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 1.5, color: Colors.black12),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
            child: ListTile(
              title: Text('Pipul $index'),
              onTap: () {},
            ),
          );
        },
        //separatorBuilder: (BuildContext context, int index) => const Divider(),
      ),
    );
  }
}
