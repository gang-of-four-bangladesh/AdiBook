import 'package:adibook/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

class FrequentWidgets {
  getSnackbar({
    String message,
    BuildContext context,
    int duration = 1,
  }) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: duration),
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppTheme.appThemeColor.withOpacity(0.9),
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

  //  ProgressDialog getLoadingProgressBar(BuildContext context,ProgressDialog pr) {
  //   ProgressDialog(context,
  //       type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
  //   pr.update(
  //     progress: 50.0,
  //     message: "Please wait...",
  //     progressWidget: Container(
  //         padding: EdgeInsets.all(8.0),
  //         child: CircularProgressIndicator(
  //             valueColor: AlwaysStoppedAnimation(AppTheme.appThemeColor),
  //             strokeWidth: 5.0)),
  //     maxProgress: 100.0,
  //     progressTextStyle: TextStyle(
  //         color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
  //     messageTextStyle: TextStyle(
  //         color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
  //   );
  //   return pr;
  // }
}

class DetailScreen extends StatelessWidget {
  final downloadUrl;
  DetailScreen({this.downloadUrl});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: 'imageHero',
            child: Image.network(
              downloadUrl,
              fit: BoxFit.contain,
            ),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
 
}
