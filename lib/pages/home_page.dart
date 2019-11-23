import 'package:adibook/core/app_data.dart';
import 'package:adibook/core/constants.dart';
import 'package:adibook/core/frequent_widgets.dart';
import 'package:adibook/core/page_manager.dart';
import 'package:adibook/data/user_manager.dart';
import 'package:adibook/pages/instructor/pupil_list_section.dart';
import 'package:adibook/pages/pupil/status_section.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class HomePage extends StatefulWidget {
  final SectionType sectionType;
  final UserType userType;
  final Widget toDisplay;
  HomePage({
    this.userType,
    this.sectionType,
    this.toDisplay,
  });
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  Logger _logger = Logger('HomePage');
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<WidgetConfiguration> _tabbarWidgetsConfig = [];
  List<WidgetConfiguration> _drawerWidgetsConfig = [];
  List<Widget> _tabWidgets = [];
  TabController _tabController;
  List<Tab> _tabs = [];
  List<Widget> _linkItems = [];

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
    setState(() {
      var widgetsConfig = PageManager().getWidgetConfigurations(
        this.widget.userType,
        this.widget.sectionType,
      );
      this._tabbarWidgetsConfig = widgetsConfig
          .where((w) => w.displayArea.any((d) => d == DisplayArea.Tab))
          .toList();
      this._drawerWidgetsConfig = widgetsConfig
          .where((w) => w.displayArea.any((d) => d == DisplayArea.Drawer))
          .toList();
      var isTabBarWidget = this._tabbarWidgetsConfig.any((t) =>
          t.sectionWidget.runtimeType == this.widget.toDisplay.runtimeType);
      var defaultSectionIndex = 0;
      if (isTabBarWidget) {
        defaultSectionIndex = this
            ._tabbarWidgetsConfig
            .firstWhere((t) =>
                t.sectionWidget.runtimeType ==
                this.widget.toDisplay.runtimeType)
            .index;
      } else {
        this._tabbarWidgetsConfig = widgetsConfig
            .where((w) =>
                w.sectionWidget.runtimeType ==
                this.widget.toDisplay.runtimeType)
            .toList();
      }
      this._tabWidgets =
          this._tabbarWidgetsConfig.map((f) => f.sectionWidget).toList();
      this._getTabs();
      this._getDrawerLinks();
      _tabController = TabController(
        vsync: this,
        initialIndex: defaultSectionIndex,
        length: this._tabWidgets.length,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: this._scaffoldKey,
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
          ),
          Container(
            padding: EdgeInsets.only(right: 2.0),
            child: Center(
              child: ButtonTheme(
                minWidth: 100.0,
                height: 60.0,
                child: IconButton(
                  icon: Icon(Icons.more),
                  onPressed: () async {
                    _scaffoldKey.currentState.openDrawer();
                  },
                ),
              ),
            ),
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: this._linkItems,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: this._tabWidgets,
      ),
    );
  }

  void _getTabs() {
    this._tabs.clear();
    this._tabbarWidgetsConfig.forEach(
        (f) => this._tabs.add(Tab(text: f.drawerLinkText.toUpperCase())));
  }

  void _getDrawerLinks() {
    this._linkItems.clear();
    this._linkItems.add(
          DrawerHeader(
            child: Text('Drawer Header'),
            decoration: BoxDecoration(
              color: AppTheme.appThemeColor,
            ),
          ),
        );
    this._linkItems.add(
          ListTile(
            title: Text("HOME"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePage(
                    userType: appData.user.userType,
                    sectionType: appData.user.userType == UserType.Instructor
                        ? SectionType.InstructorActivity
                        : SectionType.PupilActivity,
                    toDisplay: appData.user.userType == UserType.Instructor
                        ? PupilListSection()
                        : StatusSection(),
                  ),
                ),
              );
            },
          ),
        );
    this._drawerWidgetsConfig.forEach(
          (f) => this._linkItems.add(
                ListTile(
                  title: Text(f.drawerLinkText.toUpperCase()),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(
                          userType: appData.user.userType,
                          sectionType: f.sectionType,
                          toDisplay: f.sectionWidget,
                        ),
                      ),
                    );
                  },
                ),
              ),
        );
  }
}
