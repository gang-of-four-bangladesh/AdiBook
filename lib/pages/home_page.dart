import 'package:adibook/core/app_data.dart';
import 'package:adibook/core/constants.dart';
import 'package:adibook/core/page_manager.dart';
import 'package:adibook/data/user_manager.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class HomePage extends StatefulWidget {
  final SectionType sectionType;
  final UserType userType;
  final Map<String, dynamic> contextInfo;
  HomePage({
    this.userType,
    this.sectionType,
    this.contextInfo,
  });
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Logger _logger = Logger('HomePage');
  int _selectedPage;
  String _appbarTitle;
  List<WidgetConfiguration> _widgetsConfiguration = [];
  List<Widget> _widgets = [];
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
    appData.contextualInfo = this.widget.contextInfo;
    this._logger.info(
        'Contextual information ${this.widget.contextInfo}, app data information $appData');
    setState(() {
      _selectedPage = 0;
      this._widgetsConfiguration = PageManager().getWidgetConfigurations(
          this.widget.userType, this.widget.sectionType);
      this._widgets =
          _widgetsConfiguration.map((f) => f.sectionWidget).toList();
      this._logger.info(
          'selected widgets for usertype ${this.widget.userType} and section type ${this.widget.sectionType} are ${this._widgetsConfiguration.map((f) => f.appBarTitle)}');
      _appbarTitle = this._widgetsConfiguration[_selectedPage].appBarTitle;
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
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    PageRoutes.LoginPage,
                    (r) => false,
                  );
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
          children: this._widgets,
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
                  this._widgetsConfiguration[_selectedPage].appBarTitle;
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
