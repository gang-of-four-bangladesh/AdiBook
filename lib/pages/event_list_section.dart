import 'package:flutter/material.dart';
import 'package:flutter_clean_calendar/flutter_clean_calendar.dart';
import 'common_function.dart';

CommonClass commonClass = new CommonClass();
class EventListSection extends StatefulWidget {
  @override
  EventListSectionState createState() => EventListSectionState();
}

class EventListSectionState extends State<EventListSection> {
  
  @override
  Widget build(BuildContext context) {
    
    return Container(
      child: Center(
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 13.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ButtonTheme(
                      padding: EdgeInsets.all(8.0),
                      minWidth: 20.0,
                      height: 40.0,
                      child: RaisedButton(
                        color: Color(
                          commonClass.hexColor('#03D1BF'),
                        ),
                        onPressed: () {},
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(8.0),
                        ),
                        child: Text(
                          "Add Lesson",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5.0),
                    ),
                    ButtonTheme(
                      minWidth: 20.0,
                      height: 40.0,
                      child: RaisedButton(
                        color: Color(
                          commonClass.hexColor('#03D1BF'),
                        ),
                        onPressed: () {},
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(8.0),
                        ),
                        child: Text(
                          "Unavailability",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                child: Calendar(
                    events: _events,
                    onRangeSelected: (range) =>
                        print("Range is ${range.from}, ${range.to}"),
                    onDateSelected: (date) => _handleNewDate(date),
                    isExpanded: true,
                    isExpandable: true,
                    showTodayIcon: true,
                    eventDoneColor: Color(commonClass.hexColor('#03D1BF')),
                    eventColor: Color(commonClass.hexColor('#03D1BF'))),
              ),
              _buildEventList()
            ],
          ),
        ),
      ),
    );
    
  }
  Widget _buildEventList() {
    return Expanded(
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index) => Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.5, color: Colors.black12),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
          child: ListTile(
            title: Text(_selectedEvents[index]['name'].toString()),
            onTap: () {},
          ),
        ),
        itemCount: _selectedEvents.length,
      ),
    );
  }

  void _handleNewDate(date) {
    setState(() {
      _selectedDay = date;
      _selectedEvents = _events[_selectedDay] ?? [];
    });
    print(_selectedEvents);
  }

  List _selectedEvents;
  DateTime _selectedDay;

  final Map _events = {
    DateTime(2019, 7, 1): [
      {'name': 'Event A', 'isDone': true},
    ],
    DateTime(2019, 7, 3): [
      {'name': 'Event A', 'isDone': true},
      {'name': 'Event B', 'isDone': true},
    ],
    DateTime(2019, 7, 5): [
      {'name': 'Event A', 'isDone': true},
      {'name': 'Event B', 'isDone': true},
    ],
    DateTime(2019, 7, 24): [
      {'name': 'Event A', 'isDone': true},
      {'name': 'Event B', 'isDone': true},
      {'name': 'Event C', 'isDone': false},
    ],
    DateTime(2019, 7, 20): [
      {'name': 'Event A', 'isDone': true},
      {'name': 'Event B', 'isDone': true},
      {'name': 'Event C', 'isDone': false},
    ],
    DateTime(2019, 8, 26): [
      {'name': 'Event A', 'isDone': false},
    ],
  };

  @override
  void initState() {
    super.initState();
    _selectedEvents = _events[_selectedDay] ?? [];
  }
}
