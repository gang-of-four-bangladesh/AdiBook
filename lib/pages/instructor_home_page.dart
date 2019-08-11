import 'package:adibook/utils/constants.dart';
import 'package:adibook/utils/page_manager.dart';
import 'package:adibook/utils/user_manager.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'common_function.dart';

class InstructorHomePage extends StatefulWidget {
  @override
  _InstructorHomePageState createState() => _InstructorHomePageState();
}

class _InstructorHomePageState extends State<InstructorHomePage> {
  CommonClass commonClass = CommonClass();
  var _userType = UserType.Instructor;
  List<WidgetConfiguration> _widgetsConfiguration = [];

  @override
  void initState() {
    super.initState();
    _loadWidgetConfigurations();
  }

  Future _loadWidgetConfigurations() async {
    this._userType = await UserManager().currentUserType;
    setState(() {
      this._widgetsConfiguration =
          PageManager().getWidgetsConfigurationByUserType(this._userType);
    });
  }

  @override
  Widget build(BuildContext context) {
    int _selectedPage = 0;
    String _appbarTitle = "Pupil";
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(commonClass.hexColor('#03D1BF')),
        title: Text(_appbarTitle),
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
                  await UserManager().logout();
                  Navigator.of(context).pop();
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
          children: _widgetsConfiguration.map((f) => f.widget).toList(),
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
              _appbarTitle =
                  this._widgetsConfiguration[_selectedPage].appBartitle;
              //setAppbarTitle(_selectedPage);
            });
          },
          items: _buildBottomNavigationBarItems(),
        ),
      ),
    );
  }

  List<BottomNavigationBarItem> _buildBottomNavigationBarItems() {
    List<BottomNavigationBarItem> items = [];
    this._widgetsConfiguration.forEach((f) => {
          items.add(BottomNavigationBarItem(
            icon: Icon(EvaIcons.moreHorizotnalOutline, color: Colors.white),
            title: Text(
              f.bottomNavTitle,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 12.0),
            ),
          ))
        });
    return items;
  }
}
