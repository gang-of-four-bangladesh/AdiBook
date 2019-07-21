import 'package:flutter/material.dart';
import 'common_function.dart';
import 'package:flutter_applayout_demo/pages/validation.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

CommonClass commonClass = new CommonClass();
class AddPupilSection extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AddPupilSectionstate();
  }
}

class AddPupilSectionstate extends State<AddPupilSection> {
  // _formKey and _autoValidate
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate;
  String _phone;
  String _address;
  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat("EEEE, MMMM d, yyyy 'at' h:mma");
    final timeFormat = DateFormat("h:mm a");
    Validations validations = new Validations();
    DateTime date;
    TimeOfDay time;
    void _eyeTestonSwitchChanged(bool value) {
      print(switchOn_eyeTest);
    }

    void _theoryRecordonSwitchChanged(bool value) {
      switchOn_theoryRecord = value;
    }

    void _prviouseExponSwitchChanged(bool value) {
      switchOn_prviouseExp = value;
    }

    return SingleChildScrollView(
      child: Container(
        child: Form(
          child: Center(
            child: Column(children: <Widget>[
              //Picture
              Container(
                padding: EdgeInsets.all(5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                        width: 10.0,
                        height: 5.0,
                        child: Center(
                            child: ClipRRect(
                          borderRadius: BorderRadius.circular(5.0),
                          child: img == null
                              ? Text(
                                  "No Image",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )
                              : Image.file(img),
                        ))),
                  ],
                ),
              ),

              //textBoxSection,
              Container(
                padding: EdgeInsets.only(
                    top: 10.0, left: 20.0, right: 20.0, bottom: 10.0),
                child: Wrap(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        // Container(
                        //   padding: EdgeInsets.only(bottom: 5.0),
                        //   child: TextField(
                        //     keyboardType: TextInputType.text,
                        //     decoration: InputDecoration(
                        //         border: OutlineInputBorder(
                        //             borderSide: BorderSide(
                        //               color: Color(
                        //                 commonClass.commonClass.hexColor('#03D1BF'),
                        //               ),
                        //             ),
                        //             borderRadius: new BorderRadius.circular(8.0)),
                        //         hintText: "Name"),
                        //   ),
                        // ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(bottom: 5.0),
                          child: TextFormField(
                            validator: validateName,
                            onSaved: (String val) {
                              _address = val;
                            },
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.cyan[300]),
                                    borderRadius: BorderRadius.circular(8.0)),
                                hintText: "Address"),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(bottom: 5.0),
                          child: TextFormField(
                            validator: validateMobile,
                            keyboardType: TextInputType.phone,
                            onSaved: (String val) {
                              _phone = val;
                            },
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.cyan[300]),
                                    borderRadius: BorderRadius.circular(8.0)),
                                hintText: "Phone"),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(bottom: 5.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.cyan[300]),
                                    borderRadius: BorderRadius.circular(8.0)),
                                fillColor: Colors.greenAccent,
                                hintText: "License number"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              //  Date of Birth,
              Container(
                padding: EdgeInsets.only(left: 5.0, right: 20.0),
                child: Row(
                  children: [
                    Expanded(
                      /*1*/
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /*2*/
                          Container(
                            child: Row(
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(Icons.date_range),
                                  onPressed: () => {_selectDate(context)},
                                ),
                                Text(
                                  "Date Of Birth",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    /*3*/
                    Text(
                      "${date_of_birth}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),

              //  Eye test,
              Container(
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                child: Row(
                  children: [
                    Expanded(
                      /*1*/
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /*2*/
                          Container(
                            child: Text(
                              'Eye test',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    /*3*/
                    Switch(
                      value: switchOn_eyeTest,
                      onChanged: _eyeTestonSwitchChanged,
                      activeColor: Color(
                        commonClass.hexColor('#03D1BF'),
                      ),
                    )
                  ],
                ),
              ),
              //  theory record,
              Container(
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                child: Row(
                  children: [
                    Expanded(
                      /*1*/
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /*2*/
                          Container(
                            child: Text(
                              'Theory record',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    /*3*/
                    Switch(
                      value: switchOn_theoryRecord,
                      onChanged: _theoryRecordonSwitchChanged,
                      activeColor: Color(
                        commonClass.hexColor('#03D1BF'),
                      ),
                    )
                  ],
                ),
              ),
              //  Previous driving exp,
              Container(
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                child: Row(
                  children: [
                    Expanded(
                      /*1*/
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /*2*/
                          Container(
                            child: Text(
                              'Previous driving exp.',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    /*3*/
                    Switch(
                      value: switchOn_prviouseExp,
                      onChanged: _prviouseExponSwitchChanged,
                      activeColor: Color(
                        commonClass.hexColor('#03D1BF'),
                      ),
                    )
                  ],
                ),
              ),

              //  addButton,
              Container(
                padding: EdgeInsets.all(5.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          ButtonTheme(
                            minWidth: 100.0,
                            height: 30.0,
                            child: RaisedButton(
                              onPressed: _validateInputs,
                              color: Color(
                                commonClass.hexColor('#03D1BF'),
                              ),
                              child: Text(
                                "Add",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0),
                              ),
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(8.0),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(5),
                      child: Column(
                        children: <Widget>[
                          ButtonTheme(
                            minWidth: 100.0,
                            height: 30.0,
                            child: RaisedButton(
                              color: Color(
                                commonClass.hexColor('#03D1BF'),
                              ),
                              onPressed: () {
                                dialogBoxPicture(context);
                              },
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(8.0),
                              ),
                              child: Text(
                                "Picture",
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
            ]),
          ),
        ),
      ),
    );   
    
  }
   void _validateInputs() {
     commonClass.getSnackbar("called validation function", context);
      if (_formKey.currentState.validate()) {
//    If all data are correct then save data to out variables
         commonClass.getSnackbar("Valid", context);
        //_formKey.currentState.save();
      } else {
        
          commonClass.getSnackbar("Invalid", context);
//    If all data are not valid then start auto validation.
        setState(() {
          //_autoValidate = true;
        });
      }
    }

  File img;
  Future image_picker_camera() async {
    img = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {});
  }

  Future image_picker_gallary() async {
    img = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {});
  }

  bool switchOn_eyeTest = false;
  bool switchOn_theoryRecord = false;
  bool switchOn_prviouseExp = false;

  Future<void> dialogBoxPicture(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Option'),
          actions: <Widget>[
            FloatingActionButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
          content: Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.camera_alt),
                  onPressed: image_picker_camera,
                ),
                SizedBox(
                  width: 5.0,
                ),
                IconButton(
                  icon: Icon(Icons.photo_library),
                  onPressed: image_picker_gallary,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  DateTime selectedDate = DateTime.now();
  int getyear = 2019;
  String date_of_birth = '';
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(
        () {
          date_of_birth = new DateFormat('dd/MM/yyyy').format(picked);
        },
      );
    }
  }
}

String validateName(String value) {
  if (value.length < 3)
    return 'Name must be more than 2 charater';
  else
    return null;
}

String validateMobile(String value) {
// Indian Mobile number are of 10 digit only
  if (value.length != 10)
    return 'Mobile Number must be of 10 digit';
  else
    return null;
}

String validateEmail(String value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(value))
    return 'Enter Valid Email';
  else
    return null;
}
