import 'package:flutter/material.dart';

class Pupil_list_section extends StatefulWidget {
  @override
  Pupil_list_sectionState createState() => Pupil_list_sectionState();
}

class Pupil_list_sectionState extends State<Pupil_list_section> {
  @override
  Widget build(BuildContext context) {
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
