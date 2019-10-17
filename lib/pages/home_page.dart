import 'package:adibook/core/app_data.dart';
import 'package:adibook/core/constants.dart';
import 'package:adibook/core/page_manager.dart';
import 'package:adibook/data/user_manager.dart';
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

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  Logger _logger = Logger('HomePage');
  int _selectedPage;
  List<WidgetConfiguration> _widgetsConfiguration = [];
  List<Widget> _widgets = [];
  TabController _tabController;
  List<Tab> _tabs = [];

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  void _initialize() async {
    appData.contextualInfo = this.widget.contextInfo;
    this._logger.info(
        'Contextual information ${this.widget.contextInfo}, app data information appData, instructorId: ${appData.instructor.id} and pupilId: ${appData.pupil.id}');
    setState(() {
      _selectedPage = 0;
      this._widgetsConfiguration = PageManager().getWidgetConfigurations(
          this.widget.userType, this.widget.sectionType);
      this._widgets =
          _widgetsConfiguration.map((f) => f.sectionWidget).toList();
      this._logger.info(
          'selected widgets for usertype ${this.widget.userType} and section type ${this.widget.sectionType} are ${this._widgetsConfiguration.map((f) => f.appBarTitle)}');
      this._getTabs();
      _tabController = TabController(
        vsync: this,
        initialIndex: _selectedPage,
        length: this._widgets.length,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppTheme.appThemeColor,
        elevation: 0.7,
        leading: Container(
          padding: EdgeInsets.only(left: 15, top: 15),
          child: CircleAvatar(
            backgroundColor: AppTheme.appThemeColor,
            backgroundImage: AssetImage("assets/images/logo.png"),radius: 5.0,
          ),
        ),
        centerTitle: true,
        title: Title(
          child: Text(
            'AdiBook',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
          color: Colors.white,
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: this._tabs,
        ),
        actions: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 2.0),
            child: Center(
              child: ButtonTheme(
                minWidth: 100.0,
                height: 60.0,
                child: IconButton(
                  icon: Icon(Icons.power_settings_new),
                  onPressed: () async {
                    await UserManager().logout();
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      PageRoutes.LoginPage,
                      (r) => false,
                    );
                  },
                ),
              ),
            ),
          )
        ],
      ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Drawer Header'),
              decoration: BoxDecoration(
                color: AppTheme.appThemeColor,
              ),
            ),
            ListTile(
              title: Text('Item 1'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Item 2'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: this._widgets,
      ),
    );
  }

  void _getTabs() {
    this._tabs.clear();
    this._widgetsConfiguration.forEach(
        (f) => this._tabs.add(Tab(text: f.bottomNavTitle.toUpperCase())));
  }
}
