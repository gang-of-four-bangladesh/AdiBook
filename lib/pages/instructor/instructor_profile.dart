import 'package:adibook/core/app_data.dart';
import 'package:adibook/core/constants.dart';
import 'package:adibook/data/pupil_manager.dart';
import 'package:adibook/models/instructor.dart';
import 'package:adibook/utils/frequent_widgets.dart';
import 'package:flutter/material.dart';
import 'package:adibook/pages/validation.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';

class InstructorProfile extends StatefulWidget {
  final UserType userType;
  InstructorProfile({this.userType});
  @override
  State<StatefulWidget> createState() {
    return _InstructorProfile();
  }
}

class _InstructorProfile extends State<InstructorProfile> {
  String _selectedCountry = CountryWisePhoneCode2.keys.first;
  FrequentWidgets frequentWidgets = FrequentWidgets();
  // _formKey and _autoValidate
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  var pupilManager = new PupilManager();

  @override
  void initState() {
    super.initState();
    dateOfBirth = '';
    showDate = '';
    getInstructorInfo();
  }

  void getInstructorInfo() async {
    Logger logger = Logger("update pupil");
    logger.info(" Pupil Id >>>> : ${appData.pupilId}");
    // Pupil pupil = await Pupil(id: appData.pupilId).populatePupilInfo();
    Instructor instructor =
        await Instructor(id: appData.instructorId).getInstructor();
    logger.info("Pupil Model >>>> : $instructor");
    nameController.text = instructor.name;
    addressController.text = instructor.address;
    phoneController.text = instructor.phoneNumber;
    drivingLicenseController.text = instructor.licenseNo;
    setState(() {
      var format = DateFormat("MMM-dd-yyyy");
      showDate = format.format(instructor.dateOfBirth);
    });
  }

  @override
  Widget build(BuildContext context) {
    Validations validations = new Validations();

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
                            decoration: InputDecoration(
                                suffixIcon:
                                    Icon(Icons.star, color: Colors.red[600]),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: AppTheme.appThemeColor),
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
                      children: [
                        Container(
                          padding: EdgeInsets.only(bottom: 5.0),
                          child: TextFormField(
                            controller: phoneController,
                            keyboardType: TextInputType.phone,
                            enabled: false,
                            validator: validations.validatePhoneNumber,
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
                            validator: validations.validateRequired,
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
                                  onPressed: () => _selectDate(context),
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
                      "$showDate",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
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
                              onPressed: () async {
                                if (_validateInputs() == true)
                                  await _saveData();
                              },
                              color: AppTheme.appThemeColor,
                              child: Text(
                                "Update",
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
    if (_formKey.currentState.validate()) {
      //If all data are correct then save data to out variables
      if (dateOfBirth == '') {
        frequentWidgets.getSnackbar(
          message: 'Date of Birth is Required',
          context: context,
        );
        return false;
      }
      return true;
    } else {
      //If all data are not valid then start auto validation.
      return false;
    }
  }

  void _makeEmpty() {
    setState(() {
      nameController.text = '';
      addressController.text = '';
      phoneController.text = '';
      drivingLicenseController.text = '';
      dateOfBirth = '';
      showDate = '';
    });
  }

  Future<void> _saveData() async {
    Instructor instructor = new Instructor();
    instructor.id =
        '${CountryWisePhoneCode2[_selectedCountry]}${phoneController.text}';
    instructor.name = nameController.text;
    //appData.userType == UserType.Instructor
        //? pupil.phoneNumber =
            //'${CountryWisePhoneCode2[_selectedCountry]}${phoneController.text}'
        //: phoneController.text;
    instructor.address = addressController.text;
    instructor.licenseNo = drivingLicenseController.text;
    instructor.dateOfBirth = DateTime.parse(dateOfBirth.substring(6, 10) +
        '-' +
        dateOfBirth.substring(3, 5) +
        '-' +
        dateOfBirth.substring(0, 2) +
        ' 00:00:00.000');
    var result = await instructor.update();
    result == true
        ? frequentWidgets.getSnackbar(
            message: 'Instructor profile update successfully.',
            context: context,
          )
        : frequentWidgets.getSnackbar(
            message: 'Instructor profile update failed.',
            context: context,
          );
    _makeEmpty();
  }

  File img;
  Future imagePickerCamera() async {
    img = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {});
  }

  Future imagePickerGallary() async {
    img = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {});
  }

 
  TextEditingController nameController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();
  TextEditingController drivingLicenseController = new TextEditingController();
  int countryCodeIndex;
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
                  onPressed: imagePickerCamera,
                ),
                SizedBox(
                  width: 5.0,
                ),
                IconButton(
                  icon: Icon(Icons.photo_library),
                  onPressed: imagePickerGallary,
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
  String dateOfBirth = '';
  String showDate = '';
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: dateOfBirth == ''
          ? selectedDate
          : DateTime.parse(dateOfBirth.substring(6, 10) +
              '-' +
              dateOfBirth.substring(3, 5) +
              '-' +
              dateOfBirth.substring(0, 2) +
              ' 00:00:00.000'),
      firstDate: DateTime(1900, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(
        () {
          dateOfBirth = new DateFormat('dd/MM/yyyy').format(picked);
          showDate = new DateFormat('MMM-dd-yyyy').format(picked);
        },
      );
    }
  }
}
