import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        backgroundColor: Color(hexColor('#03D1BF')),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 20.0,right: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Wrap(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(bottom: 5.0),
                        child: TextField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(8.0)),
                              hintText: "User Name"),
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
                                  borderRadius: new BorderRadius.circular(8.0)),
                              hintText: "Password"),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 13.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                         ButtonTheme(
                        minWidth: 200.0,
                        height: 50.0,
                        child: RaisedButton(
                          color: Color(
                            hexColor('#03D1BF'),
                          ),
                          onPressed: () {},
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(8.0),
                          ),
                          child: Text(
                            "Login",
                            style: TextStyle(
                              color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16.0
                            ),
                          ),
                        ),
                      )
                    ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  hexColor(String colorhexcode) {
    String colornew = '0xff' + colorhexcode;
    colornew = colornew.replaceAll('#', '');
    int colorint = int.parse(colornew);
    return colorint;
  }
}
