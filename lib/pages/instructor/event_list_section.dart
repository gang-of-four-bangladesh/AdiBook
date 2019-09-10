
import 'package:adibook/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_calendar/flutter_clean_calendar.dart';
import 'package:logging/logging.dart';

class EventListSection extends StatefulWidget {
  @override
  EventListSectionState createState() => EventListSectionState();
}

class EventListSectionState extends State<EventListSection> {
  Logger _logger;
  EventListSectionState() : this._logger = Logger('page->event_list');
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
                        color: AppTheme.appThemeColor,
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
                        color: AppTheme.appThemeColor,
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
                        this._logger.info("Range is ${range.from}, ${range.to}"),
                    onDateSelected: (date) => _onDateSelected(date),
                    isExpanded: true,
                    isExpandable: true,
                    showTodayIcon: true,
                    eventDoneColor: AppTheme.appThemeColor,
                    eventColor: AppTheme.appThemeColor),
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

  void _onDateSelected(DateTime date) async {
    setState(() {
      _selectedDay = date;
      _selectedEvents = _events[_selectedDay] ?? [];
    });
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
