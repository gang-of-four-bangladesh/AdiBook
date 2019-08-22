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

  String convertTimeStampToStringDate(String _stamp,String DateFormate) {
    _stamp = _stamp.toString().substring(_stamp.toString().indexOf('=') + 1);
    _stamp = _stamp.split(',').first;
    //String date = '1515348000';
    print(_stamp);
    String dateWithT = _stamp.substring(0, 8) + 'T' + _stamp.substring(8);
    DateTime dateTime = DateTime.parse(dateWithT);
    var format = new DateFormat(DateFormate);
    return format.format(dateTime);
  }   
}
