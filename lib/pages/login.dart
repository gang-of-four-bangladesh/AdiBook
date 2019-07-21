import 'package:flutter/material.dart';

import 'common_function.dart';

CommonClass commonClass = new CommonClass();
class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        backgroundColor: Color(commonClass.hexColor('#03D1BF')),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 20.0, right: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Wrap(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        height: 80,
                        width: 32,
                          child: TextField(
                            style: TextStyle(fontSize: 8.0),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                        ),
                        Container(
                        width: 32,
                        height: 80,
                          child: TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                        ),
                        Container(
                        width: 32,
                        height: 80,
                          child: TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                        ),
                        Container(
                        width: 32,
                        height: 80,
                          child: TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                        ),
                        Container(
                        width: 32,
                        height: 80,
                          child: TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                        ),
                        Container(
                        width: 32,
                        height: 80,
                          child: TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                        ),
                        Container(
                        width: 32,
                        height: 80,
                          child: TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                        ),
                        Container(
                        width: 32,
                        height: 80,
                          child: TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                        ),
                        Container(
                        width: 32,
                        height: 80,
                          child: TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                        ),
                        Container(
                        width: 32,
                        height: 80,
                          child: TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                        ),
                        Container(
                        width: 32,
                        height: 80,
                          child: TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(8.0),
                              ),
                            ),
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
                              commonClass.hexColor('#03D1BF'),
                            ),
                            onPressed: () {},
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(8.0),
                            ),
                            child: Text(
                              "Login",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0),
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

 
}
