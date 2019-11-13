import 'package:adibook/core/app_data.dart';
import 'package:adibook/core/constants.dart';
import 'package:adibook/core/frequent_widgets.dart';
import 'package:adibook/core/page_manager.dart';
import 'package:adibook/core/push_notification_manager.dart';
import 'package:adibook/data/user_manager.dart';
import 'package:adibook/pages/entry_home_page.dart';
import 'package:adibook/pages/home_page.dart';
import 'package:adibook/pages/instructor/add_pupil_section.dart';
import 'package:adibook/pages/instructor/pupil_list_section.dart';
import 'package:adibook/pages/pupil/status_section.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logging/logging.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  PageManager _pageManager = PageManager();
  TextEditingController _countryCodeController = TextEditingController();
  TextEditingController _smsCodeController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  String verificationId;
  String _selectedCountry = CountryWisePhoneCode.keys.first;
  Logger _logger;
  UserType _selectedUserType = UserType.Instructor;
  bool _showProgressBar = false;

  _LoginPageState() {
    // if (!DeviceInfo.isOnPhysicalDevice) {
    this._phoneNumberController.text = "1234567890";
    this._smsCodeController.text = "654321";
    //}
    _logger = Logger(this.runtimeType.toString());
  }
  @override
  Widget build(BuildContext context) {
    var _screenWidth = MediaQuery.of(context).size.width;
    var _oneFourthWidth = _screenWidth / 6;
    this._countryCodeController.text = "+44";
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: AppTheme.appThemeColor,
          title: Text("AdiBook"),
        ),
        body: SingleChildScrollView(
          child: Builder(
            builder: (BuildContext _context) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: _oneFourthWidth,
                    right: _oneFourthWidth,
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 5,
                      ),
                      Image.asset("assets/images/logo.png",
                          width: 100, height: 100),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Radio(
                            value: UserType.Instructor,
                            groupValue: _selectedUserType,
                            onChanged: _onUserTypeSelected,
                            activeColor: AppTheme.appThemeColor,
                          ),
                          Text(
                            'Instructor',
                            style: TextStyle(fontSize: 16.0),
                          ),
                          Radio(
                            value: UserType.Pupil,
                            groupValue: _selectedUserType,
                            onChanged: _onUserTypeSelected,
                            activeColor: AppTheme.appThemeColor,
                          ),
                          Text(
                            'Pupil',
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ],
                      ),
                      DropdownButton<String>(
                        items: CountryWisePhoneCode.keys.map((String country) {
                          return DropdownMenuItem<String>(
                            value: country,
                            child: Text(country),
                          );
                        }).toList(),
                        onChanged: (String value) {
                          setState(() {
                            _selectedCountry = value;
                          });
                        },
                        value: _selectedCountry,
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.grey,
                            width: 1.0,
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: Text(
                          "Please enter your phone number and press Send OTP Code button.\nA sms will be sent with OTP code.",
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      TextField(
                        controller: _phoneNumberController,
                        keyboardType: TextInputType.number,
                        textAlignVertical: TextAlignVertical.bottom,
                        maxLength: 11,
                        decoration: InputDecoration(
                          hintStyle: TextStyle(color: Colors.grey),
                          hintText: "Your Phone Number",
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: RaisedButton(
                          onPressed: () {
                            _onPressSendOTPCode(_context);
                          },
                          color: Colors.green,
                          child: Text(
                            "Send OTP Code",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      TextField(
                        controller: _smsCodeController,
                        keyboardType: TextInputType.number,
                        textAlignVertical: TextAlignVertical.bottom,
                        maxLength: 6,
                        decoration: InputDecoration(
                          hintStyle: TextStyle(color: Colors.grey),
                          hintText: "Enter OTP Code",
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: RaisedButton(
                          onPressed: _onPressLoginButton,
                          child: Text(
                            "Login",
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Colors.green,
                        ),
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
          ), // This trailing comma makes auto-formatting nicer for build methods.
        ));
  }

  Future _onUserTypeSelected(value) async {
    setState(() {
      this._selectedUserType = value;
      _logger.info('User type $value selected.');
    });
  }

  /// Sign in using an sms code as input.
  Future _onPressLoginButton() async {
    await _displayProgressBar(true);
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
    await _displayProgressBar(false);
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
    await _displayProgressBar(false);
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

  Future<void> _verificationFailed(AuthException authException) async {
    await _displayProgressBar(false);
    this._logger.shout(
        "PhoneVerificationFailed. Code: ${authException.code}. Message: ${authException.message}");
  }

  Future<void> _codeSent(String verificationId, int forceResendingToken,
      BuildContext context) async {
    await _displayProgressBar(false);
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
    await _displayProgressBar(false);
    this.verificationId = verificationId;
    FrequentWidgets().getSnackbar(
      message:
          'OTP code auto retrieval failed. Please enter the OTP code sent by sms.',
      context: context,
      duration: 5,
    );
  }

  Future<void> _onPressSendOTPCode(BuildContext context) async {
    await _displayProgressBar(true);
    if (!await _checkUserInput()) return;
    var phoneNumber =
        '${CountryWisePhoneCode[_selectedCountry]}${_phoneNumberController.text}';
    this._logger.info("User phone number $phoneNumber");
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 5),
        verificationCompleted: this._verificationCompleted,
        verificationFailed: this._verificationFailed,
        codeSent: (String verificationId, [int forceResendingToken]) async {
          await this._codeSent(verificationId, forceResendingToken, context);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          this._codeAutoRetrievalTimeout(verificationId, context);
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

  Future<bool> _checkUserInput() async {
    this._logger.info("""User provided country code $_selectedCountry, 
    User entered phone number ${_phoneNumberController.text}, 
    Selected user type ${this._selectedUserType}.""");
    if (this._phoneNumberController.text.isEmpty) {
      await FrequentWidgets()
          .dialogBox(context, 'Phone number', 'Phone number cannot be empty.');
      return false;
    }
    if (this._phoneNumberController.text.length < 9) {
      await FrequentWidgets()
          .dialogBox(context, 'Phone number', "Phone number isn't correct.");
      return false;
    }
    return true;
  }
}
