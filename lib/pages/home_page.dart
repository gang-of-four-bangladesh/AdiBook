import 'package:adibook/core/app_data.dart';
import 'package:adibook/core/constants.dart';
import 'package:adibook/core/frequent_widgets.dart';
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

class _HomePageState extends State<HomePage>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  Logger _logger = Logger('HomePage');
  int _selectedPage;
  List<WidgetConfiguration> _widgetsConfig = [];
  List<Widget> _widgets = [];
  TabController _tabController;
  List<Tab> _tabs = [];

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((Duration duration) {
      if (UserManager().hasExpired(appData.user.expiryDate)) {
        this._handleExpiredUser();
        return;
      }
    });
    super.initState();
    _initialize();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    this._logger.info('Application life cycle test. Current state $state');
    if (state == AppLifecycleState.resumed) {
      if (UserManager().hasExpired(appData.user.expiryDate)) {
        this._handleExpiredUser();
        return;
      }
    }
  }

  Future _handleExpiredUser() async {
    await UserManager().logout();
    await FrequentWidgets().dialogBox(
      context,
      'Validity Expire Alert',
      "Your license has expired. Please contact administrator.",
    );
    Navigator.pushNamedAndRemoveUntil(
        context, PageRoutes.LoginPage, (r) => false);
  }

  void _initialize() async {
    appData.contextualInfo = this.widget.contextInfo;
    setState(() {
      _selectedPage = 0;
      this._widgetsConfig = PageManager().getWidgetConfigurations(
        this.widget.userType,
        this.widget.sectionType,
      );
      this._widgets = _widgetsConfig.map((f) => f.sectionWidget).toList();
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
            backgroundImage: AssetImage("assets/images/logo.png"),
            radius: 5.0,
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
                        context, PageRoutes.LoginPage, (r) => false);
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
    this._widgetsConfig.forEach(
        (f) => this._tabs.add(Tab(text: f.bottomNavTitle.toUpperCase())));
  }
}
