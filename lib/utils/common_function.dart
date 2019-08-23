import 'package:adibook/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CommonClass {
  hexColor(String colorhexcode) {
    String colornew = '0xff' + colorhexcode;
    colornew = colornew.replaceAll('#', '');
    int colorint = int.parse(colornew);
    return colorint;
  }

  getSnackbar(String message, BuildContext context) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 1),
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppTheme.appThemeColor.withOpacity(0.5),
      ),
    );
  }

 Widget getProgressBar() {
    return Container(
      margin: EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.appThemeColor),
          ),
        ],
      ),
    );
  }
}
