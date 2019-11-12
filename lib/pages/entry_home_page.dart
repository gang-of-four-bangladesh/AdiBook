import 'package:adibook/core/app_data.dart';
import 'package:adibook/core/constants.dart';
import 'package:adibook/core/frequent_widgets.dart';
import 'package:adibook/core/page_manager.dart';
import 'package:adibook/data/user_manager.dart';
import 'package:adibook/pages/instructor/add_pupil_section.dart';
import 'package:adibook/pages/instructor/pupil_activities/add_lesson_section.dart';
import 'package:flutter/material.dart';

class EntryHomePage extends StatefulWidget {
  final Widget section;
  final SectionType sectionType;
  final UserType userType;
  final Map<String, dynamic> contextInfo;

  EntryHomePage({
    Key key,
    this.section,
    this.sectionType,
    this.userType,
    this.contextInfo,
  }) : super(key: key);

  @override
  _EntryHomePageState createState() => _EntryHomePageState();
}

class _EntryHomePageState extends State<EntryHomePage>
    with WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<WidgetConfiguration> _drawerWidgetsConfig = [];
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

  void _initialize() async {
    appData.contextualInfo = this.widget.contextInfo;
    setState(() {
      var widgetsConfig = PageManager().getWidgetConfigurations(
          this.widget.userType, this.widget.sectionType).toList();
      this._drawerWidgetsConfig = widgetsConfig
          .where((w) => w.displayArea.any((d) => d == DisplayArea.Drawer))
          .toList();
      this._getDrawerLinks();
    });
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
    this._drawerWidgetsConfig.forEach(
          (f) => this._linkItems.add(
                ListTile(
                  title: Text(f.drawerLinkText.toUpperCase()),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EntryHomePage(
                          section: f.sectionWidget,
                          userType: appData.user.userType,
                          sectionType: f.sectionType,
                        ),
                      ),
                    );
                  },
                ),
              ),
        );
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
      body: this.widget.section,
    );
  }
}
