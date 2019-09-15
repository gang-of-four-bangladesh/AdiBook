import 'package:adibook/core/constants.dart';
import 'package:adibook/data/lesson_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_calendar/flutter_clean_calendar.dart';
import 'package:logging/logging.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class EventListSection extends StatefulWidget {
  @override
  EventListSectionState createState() => EventListSectionState();
}

class EventListSectionState extends State<EventListSection> {
  Logger _logger;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  EventListSectionState() : this._logger = Logger('page->event_list');
  List _selectedEvents = [];
  DateTime _selectedDay = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  Map _events = {};

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  void _initialize() async {
    this._events = await LessonManager().getLessonEvents(date: _selectedDay);
    setState(() {
      _selectedEvents = _events[_selectedDay] ?? [];
    });
  }

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _initialize();
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: _refreshController,
      onRefresh: _onRefresh,
      child: Center(
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Calendar(
                  events: _events,
                  onRangeSelected: (range) =>
                      this._logger.info("Range is ${range.from}, ${range.to}"),
                  onDateSelected: (date) => _onDateSelected(date),
                  isExpanded: true,
                  isExpandable: true,
                  showTodayIcon: true,
                  eventColor: AppTheme.calendarEventPendingColor),
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
            title: Text(
              _selectedEvents[index][LessonManager.LessonDescriptionKey]
                  .toString(),
            ),
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
      var key = DateTime(date.year, date.month, date.day);
      _selectedEvents = _events[key] ?? [];
    });
  }
}
