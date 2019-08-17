import 'package:flutter/material.dart';

class CommonClass {
  hexColor(String colorhexcode) {
    String colornew = '0xff' + colorhexcode;
    colornew = colornew.replaceAll('#', '');
    int colorint = int.parse(colornew);
    return colorint;
  }

  getSnackbar(String message, BuildContext context) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
        textAlign: TextAlign.center,
      ),
      backgroundColor: Color(
        hexColor('#03D1BF'),
      ),
    ));
  }

}
