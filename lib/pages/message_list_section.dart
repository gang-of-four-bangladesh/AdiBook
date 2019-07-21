import 'package:flutter/material.dart';
import 'common_function.dart';

CommonClass commonClass = new CommonClass();
class MessageListSection extends StatefulWidget {
  @override
  _MessagelistsectionState createState() => _MessagelistsectionState();
}

class _MessagelistsectionState extends State<MessageListSection> {
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
