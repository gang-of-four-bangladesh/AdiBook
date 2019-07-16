import 'package:flutter/material.dart';

class Message_list_section extends StatefulWidget {
  @override
  _Message_list_sectionState createState() => _Message_list_sectionState();
}

class _Message_list_sectionState extends State<Message_list_section> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 1.5, color: Colors.black12),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
            child: ListTile(
              title: Text("Message $index"),
              onTap: () {},
            ),
          );
        },
        //separatorBuilder: (BuildContext context, int index) => const Divider(),
      ),
    );
  }
}
