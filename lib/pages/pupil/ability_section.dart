import 'package:flutter/material.dart';

class AbilitySection extends StatefulWidget {
  @override
  _AbilitySectionState createState() => _AbilitySectionState();
}

class _AbilitySectionState extends State<AbilitySection> {
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
      ),
    );
  }
}
