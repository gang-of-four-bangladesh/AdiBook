import 'package:flutter/material.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
//import 'package:flutter_applayout_demo/image_upload.dart';
import 'package:flutter_applayout_demo/login.dart';
import 'package:flutter_clean_calendar/flutter_clean_calendar.dart';
import 'pupilRegistration.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:async/async.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'datetime_picker_formfield.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

Future main() async {
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MaterialApp(
    home: MyApp(),
    routes: <String, WidgetBuilder>{
      '/pupilRegistration': (BuildContext context) => new pupilRegistration(),
      '/login': (BuildContext context) => new login(),
      //'/Image_upload': (BuildContext context) => new Image_upload(),
    },
  ));
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  File img;
  Future image_picker_camera() async {
    img = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {});
  }

  Future image_picker_gallary() async {
    img = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {});
  }

  bool switchOn_eyeTest = false;
  bool switchOn_theoryRecord = false;
  bool switchOn_prviouseExp = false;
  final dateFormat = DateFormat("EEEE, MMMM d, yyyy 'at' h:mma");
  final timeFormat = DateFormat("h:mm a");
  DateTime date;
  TimeOfDay time;

  void _eyeTestonSwitchChanged(bool value) {
    print(switchOn_eyeTest);
  }

  void _theoryRecordonSwitchChanged(bool value) {
    switchOn_theoryRecord = value;
  }

  void _prviouseExponSwitchChanged(bool value) {
    switchOn_prviouseExp = value;
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
    'App Version 0.0',
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
                    //Picture
                    Container(
                      padding: EdgeInsets.all(5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                              width: 200.0,
                              height: 100.0,
                              child: Center(
                                  child: ClipRRect(
                                borderRadius: BorderRadius.circular(5.0),
                                child: img == null
                                    ? Text(
                                        "No Image",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )
                                    : Image.file(img),
                              ))),
                        ],
                      ),
                    ),

                    //textBoxSection,
                    Container(
                      padding: EdgeInsets.only(
                          top: 10.0, left: 20.0, right: 20.0, bottom: 10.0),
                      child: Wrap(
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(bottom: 5.0),
                                child: TextField(
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(
                                              hexColor('#03D1BF'),
                                            ),
                                          ),
                                          borderRadius:
                                              new BorderRadius.circular(8.0)),
                                      hintText: "Name"),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Container(
                                  padding: EdgeInsets.only(bottom: 5.0),
                                  child: TextField(
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.cyan[300]),
                                            borderRadius:
                                                BorderRadius.circular(8.0)),
                                        hintText: "Address"),
                                  )),
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(bottom: 5.0),
                                child: TextField(
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.cyan[300]),
                                          borderRadius:
                                              BorderRadius.circular(8.0)),
                                      hintText: "Phone"),
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
                                      hintText: "License number"),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    //  Date of Birth,
                    Container(
                      padding: EdgeInsets.only(left: 5.0, right: 20.0),
                      child: Row(
                        children: [
                          Expanded(
                            /*1*/
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /*2*/
                                Container(
                                  child: Row(
                                    children: <Widget>[
                                      IconButton(
                                        icon: Icon(Icons.date_range),
                                        onPressed: () => {_selectDate(context)},
                                      ),
                                      Text(
                                        "Date Of Birth",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          /*3*/
                          Text(
                            "${date_of_birth}",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),

                    //  Eye test,
                    Container(
                      padding: EdgeInsets.only(left: 20.0, right: 20.0),
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
                                    'Eye test',
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
                            value: switchOn_eyeTest,
                            onChanged: _eyeTestonSwitchChanged,
                            activeColor: Color(
                              hexColor('#03D1BF'),
                            ),
                          )
                        ],
                      ),
                    ),
                    //  theory record,
                    Container(
                      padding: EdgeInsets.only(left: 20.0, right: 20.0),
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
                                    'Theory record',
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
                            value: switchOn_theoryRecord,
                            onChanged: _theoryRecordonSwitchChanged,
                            activeColor: Color(
                              hexColor('#03D1BF'),
                            ),
                          )
                        ],
                      ),
                    ),
                    //  Previous driving exp,
                    Container(
                      padding: EdgeInsets.only(left: 20.0, right: 20.0),
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
                                    'Previous driving exp.',
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
                            value: switchOn_prviouseExp,
                            onChanged: _prviouseExponSwitchChanged,
                            activeColor: Color(
                              hexColor('#03D1BF'),
                            ),
                          )
                        ],
                      ),
                    ),

                    //  addButton,
                    Container(
                      padding: EdgeInsets.all(5.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                ButtonTheme(
                                  minWidth: 100.0,
                                  height: 30.0,
                                  child: RaisedButton(
                                    color: Color(
                                      hexColor('#03D1BF'),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pushNamed('/Image_upload');
                                    },
                                    shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(8.0),
                                    ),
                                    child: Text(
                                      "Add",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(5),
                            child: Column(
                              children: <Widget>[
                                ButtonTheme(
                                  minWidth: 100.0,
                                  height: 30.0,
                                  child: RaisedButton(
                                    color: Color(
                                      hexColor('#03D1BF'),
                                    ),
                                    onPressed: () {
                                      dialogBoxPicture(context);
                                    },
                                    shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(8.0),
                                    ),
                                    child: Text(
                                      "Picture",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
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
                              isExpanded: true,
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

  Future<void> dialogBoxPicture(BuildContext context) {
     return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Option'),
          actions: <Widget>[
            FloatingActionButton(
              child: Text('Ok'),
              onPressed: (){
                Navigator.of(context).pop();
              },
            )
          ],
          content: Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.camera_alt),
                  onPressed: image_picker_camera,
                ),
                 SizedBox(width: 5.0,),
                        IconButton(
                  icon: Icon(Icons.photo_library),
                  onPressed: image_picker_gallary,
                ),
                      
              ],
            ),
          ),
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

  DateTime selectedDate = DateTime.now();
  int getyear = 2019;
  String date_of_birth = '';
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(
        () {
          date_of_birth = new DateFormat('dd/MM/yyyy').format(picked);
        },
      );
    }
  }
}
