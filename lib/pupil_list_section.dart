import 'package:adibook/models/instructor.dart';
import 'package:adibook/models/pupil.dart';
import 'package:adibook/pages/add_pupil_section.dart';
import 'package:adibook/pages/common_function.dart';
import 'package:adibook/pages/pupil_activity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/cupertino.dart';

CommonClass commonClass = new CommonClass();

class PupilListSection extends StatefulWidget {
  @override
  PupilPistSectionState createState() => PupilPistSectionState();
}

class PupilPistSectionState extends State<PupilListSection> {
  List myList;
  ScrollController _scrollController = ScrollController();
  int _currentMax = 10;

  @override
  void initState() {
    super.initState();
    myList = List.generate(10, (i) => "Pupil : ${i + 1}");
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        //_getMoreData();
      }
    });
  }

  // _getMoreData() {
  //   for (int i = currentMax; i < currentMax + 10; i++) {
  //     myList.add("Pupil : ${i + 1}");
  //   }

  //   currentMax = currentMax + 10;

  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('pupils').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Text('Loading...');
          default:
            return new ListView(
              children: snapshot.data.documents.map(
                (DocumentSnapshot document) {
                  return new ListTile(                    
                    trailing: Icon(Icons.person),
                    title: Text(document["nam"]),
                    onTap: () {
                      Navigator.of(context).pushNamed('/pupil_activity');
                      //commonClass.getSnackbar(document["nam"], context);
                    },
                  );
                },
              ).toList(),
            );
        }
      },
      // builder: (BuildContext context,
      //           AsyncSnapshot<QuerySnapshot> snapshot) {
      //   switch (snapshot.connectionState) {
      //     case ConnectionState.waiting:
      //       return new Center(child: new CircularProgressIndicator());
      //     default:
      //       //return new ListView(children: getExpenseItems(snapshot));
      //   }
      // },
    );
  }
}

Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
  List<String> values = snapshot.data;
  return new ListView.builder(
    itemCount: values.length,
    itemBuilder: (BuildContext context, int index) {
      return new Column(
        children: <Widget>[
          new ListTile(
            title: new Text(values[index]),
          ),
          new Divider(
            height: 2.0,
          ),
        ],
      );
    },
  );
}

Future<List<String>> _getData() async {
  var values = new List<String>();
  values.add("Horses");
  values.add("Goats");
  values.add("Chickens");

  //throw new Exception("Danger Will Robinson!!!");

  await new Future.delayed(new Duration(seconds: 5));

  return values;
}

class CustomCard extends StatelessWidget {
  CustomCard({this.add, this.nam});
  final add;
  final nam;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: GestureDetector(
        onTap: () {
          //commonClass.getSnackbar("test snackbar", context);
          // Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //               builder: (context) => PupilActivity(
          //                   add: add)));
        },
        //padding: const EdgeInsets.all(3.0),
        child: Row(
          children: <Widget>[
            Text(
              add,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

// class SecondPage extends StatelessWidget {
//   SecondPage({this.add, this.nam});

//   final add;
//   final nam;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text(add),
//         ),
//         body: Center(
//           child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: <Widget>[
//                 Text(nam),
//                 RaisedButton(
//                     child: Text('Back To HomeScreen'),
//                     color: Theme.of(context).primaryColor,
//                     textColor: Colors.white,
//                     onPressed: () => Navigator.pop(context)),
//               ]),
//         ));
  
//   }
// }
