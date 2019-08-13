import 'package:adibook/utils/common_function.dart';
import 'package:adibook/utils/constants.dart';
import 'package:adibook/utils/page_manager.dart';
import 'package:adibook/utils/user_manager.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _userType = UserType.Instructor;
  List<WidgetConfiguration> _widgetsConfiguration = [];
  Logger _logger = Logger('homepage');
  int _selectedPage = 0;
  String _appbarTitle = "Pupil";

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
      this._logger.info(
          'selected widgets for usertype ${this._userType} are ${this._widgetsConfiguration.map((f) => f.appBartitle)}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(CommonClass().hexColor('#03D1BF')),
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
                  CommonClass().hexColor('#03D1BF'),
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
          children: _widgetsConfiguration.map((f) => f.sectionWidget).toList(),
        ),
      ),
      bottomNavigationBar: new Theme(
        data: Theme.of(context).copyWith(
            canvasColor: Color(CommonClass().hexColor('#03D1BF')),
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
              this._logger.info(
                  'selected page index $_selectedPage and app bar title $_appbarTitle');
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
            icon: f.bottomNavIcon,
            title: Text(
              f.bottomNavTitle,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 12.0),
            ),
          ))
        });
    if (items.length == 0) {
      items = [
        BottomNavigationBarItem(
          icon: Icon(EvaIcons.moreHorizotnalOutline, color: Colors.white),
          title: Text(
            "test 1",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 12.0),
          ),
        ),
        BottomNavigationBarItem(
          icon: Icon(EvaIcons.moreHorizotnalOutline, color: Colors.white),
          title: Text(
            "test 2",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 12.0),
          ),
        )
      ];
    }
    this._logger.info('selected bottomm navigation bars $items');
    return items;
  }
}
