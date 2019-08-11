import 'package:adibook/models/instructor.dart';
import 'package:adibook/models/pupil.dart';
import 'package:adibook/utils/device_info.dart';
import 'package:adibook/utils/pupil_manager.dart';
import 'package:adibook/utils/user_manager.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'common_function.dart';
import 'package:adibook/pages/validation.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

CommonClass commonClass = new CommonClass();

class AddPupilSection extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddPupilSectionstate();
  }
}

Pupil pupil = new Pupil();
Uuid uuid = new Uuid();

class AddPupilSectionstate extends State<AddPupilSection> {
  // _formKey and _autoValidate
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  String _name;
  String _phone;
  String _address;
  String _drivingLicensce;

  var pupilManager = new PupilManager();
  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat("EEEE, MMMM d, yyyy 'at' h:mma");
    final timeFormat = DateFormat("h:mm a");
    Validations validations = new Validations();
    DateTime date;
    TimeOfDay time;
    void _eyeTestonSwitchChanged(bool value) {
      switchOn_eyeTest = value;
    }

    void _theoryRecordonSwitchChanged(bool value) {
      switchOn_theoryRecord = value;
    }

    void _prviouseExponSwitchChanged(bool value) {
      switchOn_prviouseExp = value;
    }

    void _makeEmpty() {
      setState(() {
        nameController.text = '';
        addressController.text = '';
        phoneController.text = '';
        drivingLicenseController = null;
        date_of_birth = '';
        switchOn_eyeTest = false;
        switchOn_theoryRecord = false;
        switchOn_prviouseExp = false;
      });
    }

    return SingleChildScrollView(
      child: Container(
        child: Form(
          key: _formKey,
          autovalidate: _autoValidate,
          child: Center(
            child: Column(children: <Widget>[
              //textBoxSection,
              Container(
                padding: EdgeInsets.only(
                    top: 10.0, left: 20.0, right: 20.0, bottom: 10.0),
                child: Wrap(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(bottom: 5.0),
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            controller: nameController,
                            validator: validations.validateText,
                            onSaved: (String value) {
                              _name = value;
                            },
                            decoration: InputDecoration(
                                suffixIcon:
                                    Icon(Icons.star, color: Colors.red[600]),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(
                                        commonClass.hexColor('#03D1BF'),
                                      ),
                                    ),
                                    borderRadius:
                                        new BorderRadius.circular(8.0)),
                                hintText: "Name"),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(bottom: 5.0),
                          child: TextFormField(
                            onSaved: (String val) {
                              _address = val;
                            },
                            keyboardType: TextInputType.text,
                            controller: addressController,
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
                            controller: phoneController,
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
                            controller: drivingLicenseController,
                            validator: validations.validateText,
                            onSaved: (String value) {
                              _drivingLicensce = value;
                            },
                            decoration: InputDecoration(
                                suffixIcon:
                                    Icon(Icons.star, color: Colors.red[600]),
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
                      onChanged: (val) =>
                          setState(() => switchOn_eyeTest = val),
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
                      onChanged: (val) =>
                          setState(() => switchOn_theoryRecord = val),
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
                      onChanged: (val) =>
                          setState(() => switchOn_prviouseExp = val),
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
                            minWidth: 180.0,
                            height: 50.0,
                            child: RaisedButton(
                              onPressed: _validateInputs,
                              // == true
                              //     ? () async {
                              //         print('called');
                              //         print('year: ' +
                              //             date_of_birth.substring(6, 10));
                              //         print('day: ' +
                              //             date_of_birth.substring(0, 2));
                              //         print(date_of_birth);
                              //         print('month: ' +
                              //             date_of_birth.substring(3, 5));
                              //         pupil.id = uuid.v4();
                              //         pupil.name = nameController.text;
                              //         pupil.phoneNumber = phoneController.text;
                              //         pupil.address = addressController.text;
                              //         pupil.dateOfBirth = DateTime.parse(
                              //             date_of_birth.substring(6, 10) +
                              //                 '-' +
                              //                 date_of_birth.substring(3, 5) +
                              //                 '-' +
                              //                 date_of_birth.substring(0, 2) +
                              //                 ' 00:00:00.000');
                              //         pupil.eyeTest = switchOn_eyeTest;
                              //         pupil.previousExperience =
                              //             switchOn_prviouseExp;
                              //         pupil.theoryRecord =
                              //             switchOn_theoryRecord;
                              //         await pupil.add();
                              //         var instructor = await Instructor(
                              //                 id: await UserManager
                              //                     .currentUserId)
                              //             .getInstructor();
                              //         await pupilManager.tagPupil(
                              //             pupil, instructor);
                              //         await pupilManager.tagInstructor(
                              //             pupil, instructor);
                              //         _makeEmpty();
                              //         commonClass.getSnackbar(
                              //             "Data save successfully", context);
                              //       }
                              //     : commonClass.getSnackbar(
                              //         "data failed to save !!!", context),
                              //onPressed: _validateInputs,
                              color: Color(
                                commonClass.hexColor('#03D1BF'),
                              ),
                              child: Text(
                                "Save",
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
                  ],
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  bool _validateInputs() {
    commonClass.getSnackbar("called validation function", context);
    if (_formKey.currentState.validate()) {
//    If all data are correct then save data to out variables
      commonClass.getSnackbar("Valid", context);
      return true;
      //_formKey.currentState.save();
    } else {
      commonClass.getSnackbar("Invalid", context);
//    If all data are not valid then start auto validation.
      return false;
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
  TextEditingController nameController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();
  TextEditingController drivingLicenseController = new TextEditingController();

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
      initialDate: date_of_birth == ''
          ? selectedDate
          : DateTime.parse(date_of_birth.substring(6, 10) +
              '-' +
              date_of_birth.substring(3, 5) +
              '-' +
              date_of_birth.substring(0, 2) +
              ' 00:00:00.000'),
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
