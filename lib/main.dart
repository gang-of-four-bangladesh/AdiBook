import 'package:flutter/material.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter_applayout_demo/login.dart';
import 'package:flutter_clean_calendar/flutter_clean_calendar.dart';
import 'pupilRegistration.dart';

void main() => runApp(
  MaterialApp(
     home: MyApp(),
      routes: <String,WidgetBuilder>{
       '/pupilRegistration': (BuildContext context) => new pupilRegistration(),
       '/login': (BuildContext context) => new login(),
      },
  )
);

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
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

  int _selectedPage = 0;
  String appbarTitle = "Pupil";
  final moretabList = [
    'Finance',
    'Mileage',
    'Driving Tests',
    'Diary Setup',
    'Message All Your Pupils',
    'Internal Instructor Chat',
    'Pupil Achieves',
    'App Version 2.2',
  ];
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(hexColor('#03D1BF')),
          title: Text(appbarTitle),
          actions: <Widget>[
            Container(
              padding: EdgeInsets.only(right: 2.0),
              child: Center(
                  child: ButtonTheme(
                minWidth: 100.0,
                height: 60.0,
                child: RaisedButton(
                  color: Color(
                    hexColor('#03D1BF'),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed('/login');
                  },
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    "Logout",
                    style: TextStyle(color: Colors.white, fontSize: 18.0),
                  ),
                ),
              )),
            )
          ],
        ),
        body: Center(
          child: IndexedStack(
            index: _selectedPage,
            children: <Widget>[
              Container(
                child: ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(width: 1.5, color: Colors.black12),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0.0, vertical: 0.0),
                      child: ListTile(
                        title: Text('Pipul $index'),
                        onTap: () {},
                      ),
                    );
                  },
                  //separatorBuilder: (BuildContext context, int index) => const Divider(),
                ),
              ),
              Container(
                child: Center(
                  child: Column(children: <Widget>[
                    //textBoxSection,
                    Container(
                      padding: EdgeInsets.only(
                          top: 20.0, left: 20.0, right: 20.0, bottom: 10.0),
                      child: Wrap(
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(bottom: 5.0),
                                child: TextField(
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(
                                            hexColor('#03D1BF'),
                                          )),
                                          borderRadius:
                                              new BorderRadius.circular(8.0)),
                                      hintText: "First Name"),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Container(
                                  padding: EdgeInsets.only(bottom: 5.0),
                                  child: TextField(
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.cyan[300]),
                                            borderRadius:
                                                BorderRadius.circular(8.0)),
                                        hintText: "Last Name"),
                                  )),
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(bottom: 5.0),
                                child: TextField(
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.cyan[300]),
                                          borderRadius:
                                              BorderRadius.circular(8.0)),
                                      hintText: "Mobile No"),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(bottom: 5.0),
                                child: TextField(
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.cyan[300]),
                                          borderRadius:
                                              BorderRadius.circular(8.0)),
                                      fillColor: Colors.greenAccent,
                                      hintText: "Email"),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    //  smsonOfButtonSection,
                    Container(
                      padding: EdgeInsets.only(
                          top: 2.0, left: 20.0, right: 20.0, bottom: 0.0),
                      child: Row(
                        children: [
                          Expanded(
                            /*1*/
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /*2*/
                                Container(
                                  child: Text(
                                    'Sent Message via SMS',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          /*3*/
                          Switch(value: true, onChanged: null)
                        ],
                      ),
                    ),
                    //  emailonOfButtonSection,
                    Container(
                      padding: EdgeInsets.only(
                          bottom: 2.0, left: 20.0, right: 20.0, top: 0.0),
                      child: Row(
                        children: [
                          Expanded(
                            /*1*/
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /*2*/
                                Container(
                                  child: Text(
                                    'Sent Message via email',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          /*3*/
                          Switch(
                              value: true,
                              onChanged: null,
                              activeColor: Colors.cyan[300])
                        ],
                      ),
                    ),
                    //  addButton,
                    Container(
                      padding: EdgeInsets.all(5.0),
                      child: Column(
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              ButtonTheme(
                                minWidth: 310.0,
                                height: 50.0,
                                child: RaisedButton(
                                  color: Color(
                                    hexColor('#03D1BF'),
                                  ),
                                 onPressed: () {
                                   Navigator.of(context).pushNamed('/pupilRegistration');
                                 },
                                  shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(8.0),
                                  ),
                                  child: Text(
                                    "Add",
                                    style: TextStyle(
                                      color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16.0
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ]),
                ),
              ),
              Container(
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
                                    hexColor('#03D1BF'),
                                  ),
                                  onPressed: () {},
                                  shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(8.0),
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
                                    hexColor('#03D1BF'),
                                  ),
                                  onPressed: () {},
                                  shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(8.0),
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
                              isExpandable: true,
                              showTodayIcon: true,
                              eventDoneColor: Color(hexColor('#03D1BF')),
                              eventColor: Color(hexColor('#03D1BF'))),
                        ),
                        _buildEventList()
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                child: ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(width: 1.5, color: Colors.black12),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0.0, vertical: 0.0),
                      child: ListTile(
                        title: Text("Message $index"),
                        onTap: () {},
                      ),
                    );
                  },
                  //separatorBuilder: (BuildContext context, int index) => const Divider(),
                ),
              ),
              Container(
                child: ListView.builder(
                  itemCount: moretabList.length,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(width: 1.5, color: Colors.black12),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0.0, vertical: 0.0),
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
              ),
            ],
          ),
        ),
        bottomNavigationBar: new Theme(
          data: Theme.of(context).copyWith(
              canvasColor: Color(hexColor('#03D1BF')),
              primaryColor: Colors.red,
              textTheme: Theme.of(context)
                  .textTheme
                  .copyWith(caption: new TextStyle(color: Colors.yellow))),
          child: BottomNavigationBar(
            currentIndex: _selectedPage,
            onTap: (int index) {
              setState(() {
                _selectedPage = index;
                setAppbarTitle(_selectedPage);
              });
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(EvaIcons.person, color: Colors.white),
                title: Text(
                  "Pupil",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 12.0),
                ),
              ),
              BottomNavigationBarItem(
                icon: Icon(EvaIcons.plus, color: Colors.white),
                title: Text(
                  "Add Pupil",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 12.0),
                ),
              ),
              BottomNavigationBarItem(
                icon: Icon(EvaIcons.book, color: Colors.white),
                title: Text(
                  "Diary",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 12.0),
                ),
              ),
              BottomNavigationBarItem(
                icon: Icon(EvaIcons.bell, color: Colors.white),
                title: Text(
                  "Messages",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 12.0),
                ),
              ),
              BottomNavigationBarItem(
                icon: Icon(EvaIcons.moreHorizotnalOutline, color: Colors.white),
                title: Text(
                  "More",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 12.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  hexColor(String colorhexcode) {
    String colornew = '0xff' + colorhexcode;
    colornew = colornew.replaceAll('#', '');
    int colorint = int.parse(colornew);
    return colorint;
  }

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

  setAppbarTitle(int selectedPage) {
    selectedPage == 0 ? appbarTitle = "Pupil" : null;
    selectedPage == 1 ? appbarTitle = "Add Pupil" : null;
    selectedPage == 2 ? appbarTitle = "Diary" : null;
    selectedPage == 3 ? appbarTitle = "Your Messages" : null;
    selectedPage == 4 ? appbarTitle = "More" : null;
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
              padding:
                  const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
              child: ListTile(
                title: Text(_selectedEvents[index]['name'].toString()),
                onTap: () {},
              ),
            ),
        itemCount: _selectedEvents.length,
      ),
    );
  }

  Future navigateToSubPage(context) async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => pupilRegistration()));
  }
}
