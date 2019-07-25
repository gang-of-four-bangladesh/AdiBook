import 'package:adibook/models/user.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'add_pupil_section.dart';
import 'event_list_section.dart';
import 'common_function.dart';
import 'message_list_section.dart';
import 'more_list_section.dart';
import 'pupil_list_section.dart';

CommonClass commonClass = new CommonClass();

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedPage = 0;
  String appbarTitle = "Pupil";
  setAppbarTitle(int selectedPage) {
    selectedPage == 0 ? appbarTitle = "Pupil" : null;
    selectedPage == 1 ? appbarTitle = "Add Pupil" : null;
    selectedPage == 2 ? appbarTitle = "Diary" : null;
    selectedPage == 3 ? appbarTitle = "Your Messages" : null;
    selectedPage == 4 ? appbarTitle = "More" : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(commonClass.hexColor('#03D1BF')),
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
                  commonClass.hexColor('#03D1BF'),
                ),
                onPressed: () async {
                  var currentUser = await FirebaseAuth.instance.currentUser();
                  User user = new User(id: currentUser.uid, isVerified: false);
                  user.update();
                  FirebaseAuth.instance.signOut();
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
            PupilListSection(),
            AddPupilSection(),
            EventListSection(),
            MessageListSection(),
            MoreList()
          ],
        ),
      ),
      bottomNavigationBar: new Theme(
        data: Theme.of(context).copyWith(
            canvasColor: Color(commonClass.hexColor('#03D1BF')),
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
    );
  }
}
