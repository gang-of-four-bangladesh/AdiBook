import 'package:adibook/utils/constants.dart';
import 'package:adibook/utils/page_manager.dart';
import 'package:adibook/utils/user_manager.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class HomePage extends StatefulWidget {
  final SectionType sectionType;
  final UserType userType;
  HomePage({this.userType, this.sectionType});
  @override
  _HomePageState createState() =>
      _HomePageState(userType: this.userType, sectionType: this.sectionType);
}

class _HomePageState extends State<HomePage> {
  final SectionType sectionType;
  final UserType userType;
  _HomePageState({this.userType, this.sectionType});

  Logger _logger = Logger('HomePage');
  int _selectedPage;
  String _appbarTitle;
  List<WidgetConfiguration> _widgetsConfiguration = [];
  List<BottomNavigationBarItem> _bottomNavBarItems = [
    BottomNavigationBarItem(
      icon: Icon(
        EvaIcons.loaderOutline,
        color: AppTheme.appThemeColor,
        size: 0.0,
      ),
      title: Text(
        "Loading..",
        style: TextStyle(
          fontWeight: FontWeight.w100,
          color: AppTheme.appThemeColor,
          fontSize: 1.0,
        ),
      ),
    ),
    BottomNavigationBarItem(
      icon: Icon(EvaIcons.loaderOutline, color: Colors.white),
      title: Text(
        "Loading..",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 12.0,
        ),
      ),
    ),
    BottomNavigationBarItem(
      icon: Icon(
        EvaIcons.loaderOutline,
        color: AppTheme.appThemeColor,
        size: 0.0,
      ),
      title: Text(
        "Loading..",
        style: TextStyle(
          fontWeight: FontWeight.w100,
          color: AppTheme.appThemeColor,
          fontSize: 1.0,
        ),
      ),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  void _initialize() {
    setState(() {
      _selectedPage = 0;
      this._widgetsConfiguration = PageManager()
          .getWidgetConfigurations(this.userType, this.sectionType);
      this._logger.info(
          'selected widgets for usertype ${this.userType} and section type ${this.sectionType} are ${this._widgetsConfiguration.map((f) => f.appBartitle)}');
      _appbarTitle = this._widgetsConfiguration[_selectedPage].appBartitle;
      this._getBottomNavBarItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppTheme.appThemeColor,
        title: Text(_appbarTitle),
        actions: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 2.0),
            child: Center(
                child: ButtonTheme(
              minWidth: 100.0,
              height: 60.0,
              child: RaisedButton(
                color: AppTheme.appThemeColor,
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
            canvasColor: AppTheme.appThemeColor,
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
          items: this._bottomNavBarItems.toList(),
        ),
      ),
    );
  }

  void _getBottomNavBarItems() {
    this._bottomNavBarItems.clear();
    this._widgetsConfiguration.forEach(
          (f) => this._bottomNavBarItems.add(
                BottomNavigationBarItem(
                  icon: f.bottomNavIcon,
                  title: Text(
                    f.bottomNavTitle,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 12.0),
                  ),
                ),
              ),
        );
    _logger.info('${this._bottomNavBarItems.length} bottomm navigation bars');
  }
}
