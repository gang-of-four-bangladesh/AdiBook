import 'package:flutter/material.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  int _selectedPage = 0;
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test change from Jahir',
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(hexColor('#03D1BF')),
          title: Text("Add Pupil"),
          actions: <Widget>[
            Container(
              padding: EdgeInsets.only(right: 2.0),
              child: Center(
                  child: ButtonTheme(
                minWidth: 100.0,
                height: 50.0,
                child: RaisedButton(
                  color: Color(
                    hexColor('#03D1BF'),
                  ),
                  onPressed: () {},
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
                                    "Add",
                                    style: TextStyle(
                                      color: Colors.white,
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
                  child: Container(
                    height: 100,
                    width: 100,
                    color: Color(
                      hexColor('#03D1BF'),
                    ),
                    child: Center(
                      child: Text(
                        "Add Pupil",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                child: Center(
                  child: Container(
                    height: 100,
                    width: 100,
                    color: Color(hexColor('#03D1BF')),
                    child: Center(
                      child: Text(
                        "Book",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                child: Center(
                  child: Container(
                    height: 100,
                    width: 100,
                    color: Color(hexColor('#03D1BF')),
                    child: Center(
                      child: Text(
                        "Message",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                  child: Center(
                child: Container(
                  height: 100,
                  width: 100,
                  color: Color(
                    hexColor('#03D1BF'),
                  ),
                  child: Center(
                    child: Text(
                      "More",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
              )),
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

  Widget pupilPage = Container(
    child: Center(
      child: Column(children: <Widget>[
        //textBoxSection,
        Container(
          padding:
              EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0, bottom: 10.0),
          child: Wrap(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(bottom: 5.0),
                    child: TextField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.cyan[300]),
                              borderRadius: new BorderRadius.circular(8.0)),
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
                                borderSide: BorderSide(color: Colors.cyan[300]),
                                borderRadius: BorderRadius.circular(8.0)),
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
                              borderSide: BorderSide(color: Colors.cyan[300]),
                              borderRadius: BorderRadius.circular(8.0)),
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
                              borderSide: BorderSide(color: Colors.cyan[300]),
                              borderRadius: BorderRadius.circular(8.0)),
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
          padding:
              EdgeInsets.only(top: 2.0, left: 20.0, right: 20.0, bottom: 0.0),
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
          padding:
              EdgeInsets.only(bottom: 2.0, left: 20.0, right: 20.0, top: 0.0),
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
                  value: true, onChanged: null, activeColor: Colors.cyan[300])
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
                    height: 40.0,
                    child: RaisedButton(
                      color: Colors.cyan[300],
                      onPressed: () {},
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        "Add",
                        style: TextStyle(
                          color: Colors.white,
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
  );
  hexColor(String colorhexcode) {
    String colornew = '0xff' + colorhexcode;
    colornew = colornew.replaceAll('#', '');
    int colorint = int.parse(colornew);
    return colorint;
  }
}
