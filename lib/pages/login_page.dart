import 'package:adibook/data/user_manager.dart';
import 'package:adibook/models/user.dart';
import 'package:adibook/pages/home_page.dart';
import 'package:adibook/utils/common_function.dart';
import 'package:adibook/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logging/logging.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  CommonClass commonClass = new CommonClass();
  TextEditingController _countryCodeController = TextEditingController();
  TextEditingController _smsCodeController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  String verificationId;
  String _selectedCountry = CountryWisePhoneCode.keys.first;
  Logger _logger;
  UserType _selectedUserType = UserType.Instructor;

  _LoginPageState() {
    //  if (!DeviceInfo.isOnPhysicalDevice) {
    this._phoneNumberController.text = "1234567890";
    this._smsCodeController.text = "654321";
    //  }
    _logger = new Logger(this.runtimeType.toString());
  }
  bool _enabled = true;
  var _onPressed;
  @override
  Widget build(BuildContext context) {
    if (_enabled) {
      _onPressed = () {
        print("tap");
      };
    }
    var _screenWidth = MediaQuery.of(context).size.width;
    var _oneFourthWidth = _screenWidth / 6;
    this._countryCodeController.text = "+44";
    return new Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        backgroundColor: AppTheme.appThemeColor,
        title: Text("AdiBook"),
      ),
      body: new Center(
        child: Padding(
          padding: EdgeInsets.only(
            left: _oneFourthWidth,
            right: _oneFourthWidth,
            top: 20,
          ),
          child: new Column(
            children: <Widget>[
              Text(
                "Logo",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Radio(
                    value: UserType.Instructor,
                    groupValue: _selectedUserType,
                    onChanged: _onUserTypeSelected,
                  ),
                  Text(
                    'Instructor',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  Radio(
                    value: UserType.Pupil,
                    groupValue: _selectedUserType,
                    onChanged: _onUserTypeSelected,
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
                child: new RaisedButton(
                  onPressed: () => _onPressSendOTPCode(),
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
                  onPressed: () => _onPressLoginButton(),
                  child: Text(
                    "Login",
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.green,
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: _progressBarActive == true
                    ? new SizedBox(
                        child: new CircularProgressIndicator(
                            valueColor: new AlwaysStoppedAnimation(
                                Color(commonClass.hexColor('#03D1BF'))),
                            strokeWidth: 5.0),
                        height: 30.0,
                        width: 30.0,
                      )
                    : new Container(),
              ),
            ],
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future _onUserTypeSelected(value) async {
    setState(() {
      this._selectedUserType = value;
      _logger.info('User type $value selected.');
    });
  }

  /// Sign in using an sms code as input.
  void _onPressLoginButton() async {
    setState(() {
      _onPressed();
      _progressBarActive = false;
      _enabled = true;
    });
    if (this._smsCodeController.text.isEmpty) {
      dialogBox(context, 'OTP Code', 'OTP code cannot be empty');
      return;
    }
    if (this._smsCodeController.text.length != 6) {
      dialogBox(context, 'OTP Code', 'OTP code should be six characters.');
      return;
    }
    AuthCredential authCredential = PhoneAuthProvider.getCredential(
        verificationId: verificationId, smsCode: this._smsCodeController.text);
    var user = await _signInUser(authCredential);
    await UserManager()
        .createUser(id: user.uid, userType: this._selectedUserType);
    await User(id: user.uid, userType: this._selectedUserType).update();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(
          userType: this._selectedUserType,
          sectionType: defaultSectionType(this._selectedUserType),
          contextInfo: {
            DataSharingKeys.PupilIdKey:
                this._selectedUserType == UserType.Pupil ? user.uid : null,
            DataSharingKeys.InstructorIdKey:
                this._selectedUserType == UserType.Instructor ? user.uid : null,
            DataSharingKeys.UserTypeKey: this._selectedUserType,
          },
        ),
      ),
    );
  }

  Future<FirebaseUser> _signInUser(AuthCredential authCredential) async {
    var user = await FirebaseAuth.instance.signInWithCredential(authCredential);
    final FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    assert(user.uid == currentUser.uid);
    var message =
        'signed in with phone number successful. sms code -> ${this._smsCodeController.text}, user -> $user';
    _logger.fine(message);
    return currentUser;
  }

  /// Sends the code to the specified phone number.
  Future<void> _onPressSendOTPCode() async {
    setState(() {
      _onPressed();
      _progressBarActive = true;
      _enabled = false;
    });
    if (this._phoneNumberController.text.isEmpty) {
      dialogBox(context, 'Phone number', 'Phone number cannot be empty.');
      return;
    }
    if (this._phoneNumberController.text.length < 9) {
      dialogBox(context, 'Phone number', "Phone number isn't correct.");
      return;
    }
    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential authCredential) async {
      var user =
          await FirebaseAuth.instance.signInWithCredential(authCredential);
      final FirebaseUser currentUser =
          await FirebaseAuth.instance.currentUser();
      assert(user.uid == currentUser.uid);
      var message =
          'PhoneVerificationCompleted. signed in with phone number successful. sms code -> ${this._smsCodeController.text}, user -> $user';
      _logger.fine(message);
      await UserManager()
          .createUser(id: user.uid, userType: this._selectedUserType);
      await User(id: user.uid, userType: this._selectedUserType).update();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(
            userType: this._selectedUserType,
            sectionType: defaultSectionType(this._selectedUserType),
            contextInfo: {
              DataSharingKeys.PupilIdKey:
                  this._selectedUserType == UserType.Pupil ? user.uid : null,
              DataSharingKeys.InstructorIdKey:
                  this._selectedUserType == UserType.Instructor
                      ? user.uid
                      : null,
              DataSharingKeys.UserTypeKey: this._selectedUserType,
            },
          ),
        ),
      );
    };

    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
      var message =
          'PhoneVerificationFailed. Code: ${authException.code}. Message: ${authException.message}';
      this._logger.shout(message);
    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      this.verificationId = verificationId;
      var message =
          "PhoneCodeSent. code sent to " + _phoneNumberController.text;
      this._logger.fine(message);
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      this.verificationId = verificationId;
      var message = "PhoneCodeAutoRetrievalTimeout. time out";
      this._logger.shout(message);
      setState(() {
        _progressBarActive = false;
        _enabled = true;
      });
    };
    var userPhoneNumber =
        '${CountryWisePhoneCode[_selectedCountry]}${_phoneNumberController.text}';
    this._logger.info(
        'User provided country code $_selectedCountry, User entered phone number ${_phoneNumberController.text}, selected user type ${this._selectedUserType}.');
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: userPhoneNumber,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  bool _progressBarActive = false;
  Future<void> dialogBox(BuildContext context, String title, String message) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
