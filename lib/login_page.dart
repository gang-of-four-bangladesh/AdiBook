import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _countryCodeController = TextEditingController();
  TextEditingController _smsCodeController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  String verificationId;

  @override
  Widget build(BuildContext context) {
    var screen_width = MediaQuery.of(context).size.width;
    var screen_height = MediaQuery.of(context).size.height;
    var one_fourth_width = screen_width / 6;
    _smsCodeController.text = '123456';
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Login Test"),
      ),
      body: new Center(
        child: Padding(
          padding:
              EdgeInsets.only(left: one_fourth_width, right: one_fourth_width),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new TextField(
                controller: _countryCodeController,
                readOnly: true,
                enabled: false,
                textAlignVertical: TextAlignVertical.bottom,
                decoration: InputDecoration(
                  hintText: "United Kingdom (+44)",
                  hintStyle: TextStyle(color: Colors.green),
                ),
              ),
              new TextField(
                controller: _phoneNumberController,
                keyboardType: TextInputType.number,
                textAlignVertical: TextAlignVertical.bottom,
                maxLength: 11,
                decoration: InputDecoration(
                  hintText: "Your Phone Number",
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(Icons.phone),
                  alignLabelWithHint: true,
                  labelText: "Phone Number"
                ),
              ),
              new TextField(controller: _smsCodeController),
              new FlatButton(
                  onPressed: () =>
                      _signInWithPhoneNumber(_smsCodeController.text),
                  child: const Text("Sign In"))
            ],
          ),
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () => _sendCodeToPhoneNumber(),
        tooltip: 'get code',
        child: new Icon(Icons.send),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  /// Sign in using an sms code as input.
  void _signInWithPhoneNumber(String smsCode) async {
    AuthCredential authCredential = PhoneAuthProvider.getCredential(
        verificationId: verificationId, smsCode: smsCode);
    await FirebaseAuth.instance
        .signInWithCredential(authCredential)
        .then((FirebaseUser user) async {
      final FirebaseUser currentUser =
          await FirebaseAuth.instance.currentUser();
      assert(user.uid == currentUser.uid);
      var message = 'signed in with phone number successful: user -> $user';
      print(message);
      dialogBox(context, 'Signed status', message);
    });
  }

  /// Sends the code to the specified phone number.
  Future<void> _sendCodeToPhoneNumber() async {
    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential authCredential) {
      setState(() {
        var message =
            'Inside _sendCodeToPhoneNumber: signInWithPhoneNumber auto succeeded.';
        print(message);
        dialogBox(context, 'Signed status', message);
      });
    };

    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
      setState(() {
        var message =
            'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}';
        print(message);
        dialogBox(context, 'Signed status', message);
      });
    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      this.verificationId = verificationId;
      var message = "code sent to " + _phoneNumberController.text;
      print(message);
      dialogBox(context, 'Signed status', message);
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      this.verificationId = verificationId;
      var message = "time out";
      print(message);
      dialogBox(context, 'Signed status', message);
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: _phoneNumberController.text,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

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
