import 'package:adibook/core/constants.dart';
import 'package:adibook/utils/common_function.dart';
import 'package:flutter/material.dart';

class PupilRegistration extends StatefulWidget {
  @override
  _PupilRegistrationState createState() => _PupilRegistrationState();
}

class _PupilRegistrationState extends State<PupilRegistration> {
  // _formKey and _autoValidate
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Container(
          child: Form(
            key: _formKey,
            autovalidate: _autoValidate,
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(
                      top: 20.0, left: 20.0, right: 20.0, bottom: 10.0),
                  child: Wrap(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(bottom: 5.0),
                            child: TextField(
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(8.0)),
                                  hintText: "First Name"),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Container(
                              padding: EdgeInsets.only(bottom: 5.0),
                              child: TextField(
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.cyan[300]),
                                        borderRadius:
                                            BorderRadius.circular(8.0)),
                                    hintText: "Last Name"),
                              )),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(bottom: 5.0),
                            child: TextField(
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.cyan[300]),
                                      borderRadius: BorderRadius.circular(8.0)),
                                  hintText: "Instructor"),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(bottom: 5.0),
                            child: TextField(
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.cyan[300]),
                                      borderRadius: BorderRadius.circular(8.0)),
                                  fillColor: Colors.greenAccent,
                                  hintText: "Phone Number"),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Container(
                              padding: EdgeInsets.only(bottom: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                      'Password must contain 7 characters with at least one'),
                                ],
                              )),
                          Container(
                              padding: EdgeInsets.only(bottom: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text('number'),
                                ],
                              )),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(bottom: 5.0),
                            child: TextField(
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.cyan[300]),
                                      borderRadius: BorderRadius.circular(8.0)),
                                  fillColor: Colors.greenAccent,
                                  hintText: "Password"),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(bottom: 0.0),
                            child: TextField(
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.cyan[300]),
                                      borderRadius: BorderRadius.circular(8.0)),
                                  fillColor: Colors.greenAccent,
                                  hintText: "Confirm Password"),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                      top: 2.0, left: 25.0, right: 20.0, bottom: 0.0),
                  child: Row(
                    children: [
                      Expanded(
                        /*1*/
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /*2*/
                            Container(
                              child: new RichText(
                                text: new TextSpan(
                                  // Note: Styles for TextSpans must be explicitly defined.
                                  // Child text spans will inherit styles from parent
                                  style: new TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.black,
                                  ),
                                  children: <TextSpan>[
                                    new TextSpan(text: 'I agree to the '),
                                    new TextSpan(
                                      text: 'Terms and Conditions',
                                      style: new TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.appThemeColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      /*3*/
                      Switch(value: true, onChanged: null)
                    ],
                  ),
                ),
                //  emailonOfButtonSection,
                //RegistrationButton
                Container(
                  padding: EdgeInsets.all(5.0),
                  child: Column(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          ButtonTheme(
                            minWidth: 310.0,
                            height: 50.0,
                            child: RaisedButton(
                              color: AppTheme.appThemeColor,
                              onPressed: () {},
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(8.0),
                              ),
                              child: Text(
                                "Register",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
