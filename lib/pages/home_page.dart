import 'dart:io';

import 'package:adibook/core/app_data.dart';
import 'package:adibook/core/constants.dart';
import 'package:adibook/core/frequent_widgets.dart';
import 'package:adibook/core/page_manager.dart';
import 'package:adibook/data/user_manager.dart';
import 'package:adibook/models/instructor.dart';
import 'package:adibook/pages/instructor/pupil_list_section.dart';
import 'package:adibook/pages/pupil/status_section.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logging/logging.dart';
import 'package:progress_dialog/progress_dialog.dart';

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
  File img;
  String userName = EmptyString;
  String phoneNo = EmptyString;
  Instructor instructor;
  final ImagePicker _imagePicker = ImagePicker();
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

  void _initialize() {
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
              t.sectionWidget.runtimeType == this.widget.toDisplay.runtimeType)
          .index;
    } else {
      this._tabbarWidgetsConfig = widgetsConfig
          .where((w) =>
              w.sectionWidget.runtimeType == this.widget.toDisplay.runtimeType)
          .toList();
    }
    this._tabWidgets =
        this._tabbarWidgetsConfig.map((f) => f.sectionWidget).toList();
    this._getTabs();
    _tabController = TabController(
      vsync: this,
      initialIndex: defaultSectionIndex,
      length: this._tabWidgets.length,
    );
    if (!mounted) return;
    setState(() {
      this._getDrawerLinks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      key: this._scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppTheme.appThemeColor,
        elevation: 0.7,
        leading: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(right: 2.0),
                  child: Center(
                    child: ButtonTheme(
                      minWidth: 100.0,
                      height: 60.0,
                      child: IconButton(
                        icon: Icon(
                          Icons.menu,
                          size: 35,
                        ),
                        onPressed: () async {
                          _scaffoldKey.currentState.openDrawer();
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        centerTitle: true,
        title: Title(
            color: Colors.white,
            child: Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    child: Container(
                      child: Image.asset(
                        "assets/images/logo.png",
                        width: 45,
                        height: 45,
                      ),
                    ),
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePage(
                            userType: appData.user.userType,
                            sectionType:
                                appData.user.userType == UserType.Instructor
                                    ? SectionType.InstructorActivity
                                    : SectionType.PupilActivity,
                            toDisplay:
                                appData.user.userType == UserType.Instructor
                                    ? PupilListSection()
                                    : StatusSection(),
                          ),
                        ),
                        (r) => false,
                      );
                    },
                  ),

                  // SizedBox(
                  //   width: 8,
                  // ),
                  Text(
                    'AdiBook',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Colors.white),
                  ),
                ],
              ),
            )),
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
    ));
  }

  void _getTabs() {
    this._tabs.clear();
    this._tabbarWidgetsConfig.forEach(
        (f) => this._tabs.add(Tab(text: f.drawerLinkText.toUpperCase())));
  }

  void _getDrawerLinks() {
    this._linkItems.clear();
    this._linkItems.add(
          ClipPath(
            clipper: MyClipper(),
            clipBehavior: Clip.antiAlias,
            child: Container(
              padding: EdgeInsets.only(left: 5, right: 5, bottom: 15, top: 5),
              child: DrawerHeader(
                  decoration: BoxDecoration(
                    gradient: AppTheme.appThemeGradienColor,
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 8),
                        blurRadius: 24,
                        color: kShadowColor,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(bottom: 15),
                          child: Text('AdiBook',
                              style: TextStyle(
                                  fontSize: 25, color: Colors.white))),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: 75,
                            height: 75,
                            child: GestureDetector(
                              child: getImage(img),
                              onTap: () {
                                dialogBoxPicture(context);
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                      text: appData.user.userType ==
                                              UserType.Instructor
                                          ? "${appData.instructor.name == null || appData.instructor.name == EmptyString ? 'Add Name' : appData.instructor.name}\n${appData.instructor.phoneNumber}"
                                          : "${appData.pupil.name}\n${appData.pupil.phoneNumber}",
                                      style: TextStyle(fontSize: 14)),
                                ],
                              ),
                            ),
                          ),
                          // SizedBox(
                          //   width: 20,
                          // ),
                          //Text(phoneNo)
                        ],
                      ),
                    ],
                  )),
            ),
          ),
        );
    this._linkItems.add(
          ListTile(
            title: Row(
              children: [
                Icon(
                  Icons.home,
                  color: Colors.grey[400],
                ),
                Text("  HOME")
              ],
            ),
            onTap: () {
              Navigator.pushAndRemoveUntil(
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
                (r) => false,
              );
            },
          ),
        );
    this._drawerWidgetsConfig.forEach(
          (f) => this._linkItems.add(
                ListTile(
                  title: Row(
                    children: [
                      Icon(
                        getDrawerItemIcon(f.drawerLinkText.toUpperCase()),
                        color: Colors.grey[400],
                      ),
                      Text("  ${f.drawerLinkText.toUpperCase()}")
                    ],
                  ),
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(
                          userType: appData.user.userType,
                          sectionType: f.sectionType,
                          toDisplay: f.sectionWidget,
                        ),
                      ),
                      (r) => false,
                    );
                  },
                ),
              ),
        );
  }

  IconData getDrawerItemIcon(String itemName) {
    if (itemName == "PUPILS") {
      return Icons.group;
    }
    if (itemName == "NEW PUPIL") {
      return Icons.person_add;
    }
    if (itemName == "DIARY") {
      return EvaIcons.book;
    }
    if (itemName == "PROFILE") {
      return Icons.person;
    }
    if (itemName == "LESSONS") {
      return EvaIcons.bookOpenOutline;
    }
    if (itemName == "PAYMENTS") {
      return Icons.monetization_on;
    }
    if (itemName == "PROGRESS") {
      return Icons.work;
    }
    if (itemName == "ADD LESSON") {
      return Icons.add_box;
    }
    if (itemName == "ADD PAYMENT") {
      return Icons.add_circle;
    }
    if (itemName == "STATUS") {
      return Icons.blur_on;
    }
    if (itemName == "TERMS AND CONDITIONS") {
      return Icons.security;
    }
  }

  ProgressDialog getLoadingProgressBar(
      BuildContext context, ProgressDialog pr) {
    ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    pr.update(
      progress: 50.0,
      message: "Please wait...",
      progressWidget: Container(
          padding: EdgeInsets.all(8.0),
          child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(AppTheme.appThemeColor),
              strokeWidth: 5.0)),
      maxProgress: 100.0,
      progressTextStyle: TextStyle(
          color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
    );
    return pr;
  }

  Future imagePickerCamera() async {
    Navigator.of(context).pop();
    var imagePath =
        await this._imagePicker.getImage(source: ImageSource.camera);
    if (imagePath != null) {
      setState(() {
        img = File(imagePath.path);
        print(img);
        getImage(img);
      });
      await confirmUploadProfilePicture(img);
    }
  }

  Future imagePickerGallary() async {
    Navigator.of(context).pop();
    var imagePath =
        await this._imagePicker.getImage(source: ImageSource.gallery);
    if (imagePath != null) {
      setState(() {
        img = File(imagePath.path);
        print(img);
        getImage(img);
      });
      await confirmUploadProfilePicture(img);
    }
  }

  dynamic confirmUploadProfilePicture(File image) async {
    await showDialog(
        context: context,
        builder: (_) => AlertDialog(
              contentPadding: EdgeInsets.only(top: 10.0),
              content: Container(
                width: 300.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[300],
                    gradient: AppTheme.appThemeGradienGreyColor),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text("Upload profile picture ?",
                            style: TextStyle(fontSize: 24.0),
                            textAlign: TextAlign.center)
                      ],
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Divider(
                      color: Colors.grey,
                      height: 4.0,
                    ),
                    Padding(
                      padding: EdgeInsets.all(30),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CircleAvatar(
                            radius: 80,
                            backgroundImage: FileImage(image),
                          )
                        ],
                      ),
                    ),
                    InkWell(
                      child: Container(
                        padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                        decoration: BoxDecoration(
                          color: AppTheme.appThemeColor,
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(left: 30, right: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              FloatingActionButton(
                                backgroundColor: Colors.green.withOpacity(0.6),
                                child: Text('Yes'),
                                onPressed: () {
                                  Navigator.of(context).pop(true);
                                },
                              ),
                              FloatingActionButton(
                                backgroundColor: Colors.red.withOpacity(0.6),
                                child: Text('No'),
                                onPressed: () {
                                  Navigator.of(context).pop(false);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ));
  }

  Future<void> dialogBoxPicture(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            width: MediaQuery.of(context).size.width / 2,
            height: MediaQuery.of(context).size.height / 6,
            child: Padding(
                padding: EdgeInsets.all(5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Icon(
                            Icons.camera_alt,
                            size: 40,
                            color: Colors.black26,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Take new photo",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      onTap: imagePickerCamera,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Icon(
                            Icons.photo,
                            size: 40,
                            color: Colors.black26,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Select from gallery",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      onTap: imagePickerGallary,
                    )
                  ],
                )),
          ),
        );
      },
    );
  }

  CircleAvatar getImage(File img) {
    return CircleAvatar(
      backgroundColor: img == null ? Colors.grey : AppTheme.appThemeColor,
      child: img == null
          ? Icon(
              Icons.person,
              color: Colors.white,
              size: 40,
            )
          : Image.file(File(img.path)),
    );
  }
}
