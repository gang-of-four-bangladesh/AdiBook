import 'dart:io';
import 'dart:typed_data';
import 'package:adibook/core/app_data.dart';
import 'package:adibook/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:adibook/core/frequent_widgets.dart';
import 'package:adibook/core/page_manager.dart';
import 'package:adibook/core/push_notification_manager.dart';
import 'package:adibook/core/widgets/toogle_switch.dart';
import 'package:adibook/data/user_manager.dart';
import 'package:adibook/pages/home_page.dart';
import 'package:adibook/pages/instructor/pupil_list_section.dart';
import 'package:adibook/pages/pupil/status_section.dart';
import 'package:adibook/pages/validation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:logging/logging.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //terms and condition start
  String path;
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/exemplo.pdf');
  }

  Future<File> writeCounter(Uint8List stream) async {
    final file = await _localFile;
    // Write the file
    return file.writeAsBytes(stream);
  }

  Future<Uint8List> fetchPost() async {
    final response = await http.get(
        'https://firebasestorage.googleapis.com/v0/b/gofbd-adibook.appspot.com/o/app_docs%2Fpupils%2Fpc_configuration.pdf?alt=media&token=3c4f8489-d3e7-42e2-914c-0d5a38721724');
    final responseJson = response.bodyBytes;

    return responseJson;
  }

  loadPdf() async {
   writeCounter(await fetchPost());
   path = (await _localFile).path;

   if (!mounted) return;

    setState(() {});
  }

  PageManager _pageManager = PageManager();
  TextEditingController _countryCodeController = TextEditingController();
  TextEditingController _smsCodeController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  String verificationId;
  Logger _logger;
  ProgressDialog pr;
  String countryCode = "+44";
  UserType _selectedUserType = UserType.Instructor;
  bool _showProgressBar = false;

  _LoginPageState() {
    //this._phoneNumberController.text = "1234567890";
    _logger = Logger(this.runtimeType.toString());
  }
  @override
  void initState() {
    super.initState();
    pr = ProgressDialog(context,
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
          color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.w600),
    );
    loadPdf();
  }

  @override
  Widget build(BuildContext context) {
    var _screenWidth = MediaQuery.of(context).size.width;
    var _oneSixthWidth = _screenWidth / 8;
    var pageWidth = _screenWidth - (_oneSixthWidth * 2);
    this._countryCodeController.text = "+44";
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppTheme.appThemeColor,
        title: Text("AdiBook"),
      ),
      body: Builder(
        builder: (BuildContext _context) {
          return Center(
            child: Padding(
              padding: EdgeInsets.only(
                left: _oneSixthWidth,
                right: _oneSixthWidth,
              ),
              child: ListView(
                children: <Widget>[
                  ToggleSwitch(
                    minWidth: pageWidth / 2,
                    initialLabelIndex: 0,
                    activeBgColor: Colors.grey[100].withOpacity(0.6),
                    activeTextColor: Colors.grey[100].withOpacity(0.1),
                    inactiveBgColor: Colors.grey[100].withOpacity(0.1),
                    inactiveTextColor: Colors.grey[100].withOpacity(0.1),
                    labels: ['UK', 'BD'],
                    icons: [FontAwesomeIcons.airbnb, FontAwesomeIcons.flag],
                    onToggle: (index) async {
                      this.countryCode = index == 0 ? "+44" : "+88";
                      this
                          ._logger
                          .info('Selected Country Code ${this.countryCode}');
                    },
                  ),
                  //SizedBox(height: 40),
                  Image.asset(
                    "assets/images/logo.png",
                    width: 100,
                    height: 100,
                  ),
                  SizedBox(height: 20),
                  ToggleSwitch(
                    minWidth: pageWidth / 2,
                    initialLabelIndex: 0,
                    activeBgColor: AppTheme.appThemeColor.withOpacity(0.6),
                    activeTextColor: Colors.white,
                    inactiveBgColor: Colors.grey,
                    inactiveTextColor: Colors.grey[900],
                    labels: ['Instructor', 'Pupil'],
                    icons: [
                      FontAwesomeIcons.solidUserCircle,
                      FontAwesomeIcons.userGraduate
                    ],
                    onToggle: (index) {
                      if (index == 0) {
                        this._selectedUserType = UserType.Instructor;
                      } else if (index == 1) {
                        this._selectedUserType = UserType.Pupil;
                      }
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _phoneNumberController,
                    keyboardType: TextInputType.phone,
                    //validator: Validations().validatePhoneNumber,
                    maxLength: 11,
                    decoration: InputDecoration(
                        icon: Icon(FontAwesomeIcons.phoneAlt),
                        suffixIcon: Icon(
                          Icons.star,
                          color: Colors.red[600],
                          size: 15,
                        ),
                        hintStyle: TextStyle(color: Colors.grey),
                        hintText: '+44 will be prepended.',
                        labelText: "Phone(+44)"),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: this._showProgressBar == false
                        ? SizedBox(child: saveButton(_context))
                        : Container(),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: _showProgressBar == true
                        ? SizedBox(
                            child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation(
                                    AppTheme.appThemeColor),
                                strokeWidth: 5.0),
                            height: 30.0,
                            width: 30.0,
                          )
                        : Container(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// Sign in using an sms code as input.
  Future _onPressLoginButton() async {
    await pr.show();
    if (this._smsCodeController.text.isEmpty) {
      await FrequentWidgets()
          .dialogBox(context, 'OTP Code', 'OTP code cannot be empty');
      return;
    }
    if (this._smsCodeController.text.length != 6) {
      await FrequentWidgets()
          .dialogBox(context, 'OTP Code', 'OTP code should be six characters.');
      return;
    }
    AuthCredential authCredential = PhoneAuthProvider.getCredential(
      verificationId: verificationId,
      smsCode: this._smsCodeController.text,
    );
    var user = await _signInUser(authCredential);
    var _userToken = await FirebaseCloudMessaging.getToken();
    await UserManager().createUser(
      id: user.phoneNumber,
      userType: this._selectedUserType,
      token: _userToken,
    );
    if (await UserManager().hasUserExpired(user.phoneNumber)) {
      this._handleExpiredUser();
      return;
    }
    await UserManager().updateAppDataByUserId(user.phoneNumber);
    await pr.dismiss();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(
          userType: this._selectedUserType,
          sectionType: _pageManager.defaultSectionType(this._selectedUserType),
          toDisplay: appData.user.userType == UserType.Instructor
              ? PupilListSection()
              : StatusSection(),
        ),
      ),
    );
  }

  Future<FirebaseUser> _signInUser(AuthCredential authCredential) async {
    var authResult =
        await FirebaseAuth.instance.signInWithCredential(authCredential);
    final FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    assert(authResult.user.phoneNumber == currentUser.phoneNumber);
    var message =
        'signed in with phone number successful. sms code -> ${this._smsCodeController.text}, user -> ${authResult.user}';
    _logger.fine(message);
    return currentUser;
  }

  Future<void> _displayProgressBar(bool status) async {
    setState(() {
      this._showProgressBar = status;
    });
  }

  Future<void> _verificationCompleted(AuthCredential authCredential) async {
    var authResult =
        await FirebaseAuth.instance.signInWithCredential(authCredential);
    final FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    assert(authResult.user.phoneNumber == currentUser.phoneNumber);
    var _userToken = await FirebaseCloudMessaging.getToken();
    await UserManager().createUser(
      id: currentUser.phoneNumber,
      userType: this._selectedUserType,
      token: _userToken,
    );
    if (await UserManager().hasUserExpired(currentUser.phoneNumber)) {
      this._handleExpiredUser();
      return;
    }
    await UserManager().updateAppDataByUserId(currentUser.phoneNumber);
    await pr.dismiss();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(
          userType: this._selectedUserType,
          sectionType: _pageManager.defaultSectionType(this._selectedUserType),
          toDisplay: appData.user.userType == UserType.Instructor
              ? PupilListSection()
              : StatusSection(),
        ),
      ),
    );
  }

  Future<void> _verificationFailed(
      AuthException authException, BuildContext context) async {
    await pr.dismiss();
    this._logger.shout(
        "PhoneVerificationFailed. Code: ${authException.code}. Message: ${authException.message}");
    FrequentWidgets().getSnackbar(
      message: authException.message,
      context: context,
      duration: 5,
    );
  }

  Future<void> _codeSent(String verificationId, int forceResendingToken,
      BuildContext context) async {
    //await _displayProgressBar(false);
    this.verificationId = verificationId;
    FrequentWidgets().getSnackbar(
      message:
          'OTP code sent to phone number ${this._phoneNumberController.text}.',
      context: context,
      duration: 5,
    );
  }

  Future<void> _codeAutoRetrievalTimeout(
      String verificationId, BuildContext context) async {
    await pr.dismiss();
    this.verificationId = verificationId;
    FrequentWidgets().getSnackbar(
      message:
          'We were unable to retrieve OTP code. Please check your phone number is correct!',
      context: context,
      duration: 5,
    );
  }

  Future<String> _addCountryCodeToPhoneNumber() async {
    if (this._phoneNumberController.text.startsWith(this.countryCode))
      return this._phoneNumberController.text;
    return "$countryCode" + "${this._phoneNumberController.text}";
  }

  Future<void> _onPressSendOTPCode(BuildContext context) async {
    if (this._selectedUserType ==
        UserType.Instructor) if (!await _hasValidInput()) return;
    var phoneNumber = await _addCountryCodeToPhoneNumber();
    this._logger.info(phoneNumber);
    await pr.show();
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 5),
      verificationCompleted: this._verificationCompleted,
      verificationFailed: (AuthException authException) async {
        await this._verificationFailed(authException, context);
      },
      codeSent: (String verificationId, [int forceResendingToken]) async {
        await this._codeSent(verificationId, forceResendingToken, context);
        if (phoneNumber == "+441234567890") {
          this._smsCodeController.text = "654321";
          await _onPressLoginButton();
        }
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        this._codeAutoRetrievalTimeout(verificationId, context);
      },
    );
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

  Future<bool> _hasValidInput() async {
    var message =
        Validations().validatePhoneNumber(this._phoneNumberController.text);
    if (message == null) return true;
    await FrequentWidgets().dialogBox(context, 'Phone number', message);
    return false;
  }

  Future<void> _confirmation(BuildContext _context) async {
    if (!await _hasValidInput()) return;
    loadPdf();
    showDialog<ConfirmAction>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
              child: Text(
            "Terms and Conditions",
            style: TextStyle(color: Colors.red),
          )),
          content:
              //SingleChildScrollView(
              //child:
              Center(
            child: Column(
              children: <Widget>[
                if (path != null)
                  Container(
                    margin: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border:
                          Border.all(width: 3, color: AppTheme.appThemeColor),
                    ),
                    height: MediaQuery.of(context).size.height / 1.48,
                    width: MediaQuery.of(context).size.width,
                    child: PdfViewer(
                      filePath: path,
                    ),
                  )
              ],
            ),
            //),
          ),
          actions: <Widget>[
            FlatButton(
              child: const Text('REJECT'),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.CANCEL);
              },
            ),
            FlatButton(
              child: const Text('ACCEPT'),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.CANCEL);
                _onPressSendOTPCode(_context);
              },
            )
          ],
        );
      },
    );
  }

  Widget saveButton(BuildContext _context) {
    return RaisedButton(
      onPressed: () {
        if (this._showProgressBar == false)
         if (this._selectedUserType == UserType.Pupil)
          _confirmation(_context);
        else
          _onPressSendOTPCode(_context);
      },
      elevation: 1,
      color: AppTheme.appThemeColor.withOpacity(0.6),
      child: Text(
        "Login",
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
