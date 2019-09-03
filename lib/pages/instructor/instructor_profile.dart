import 'package:adibook/core/app_data.dart';
import 'package:adibook/core/constants.dart';
import 'package:adibook/core/frequent_widgets.dart';
import 'package:adibook/models/instructor.dart';
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
  var _logger = Logger("instructor->information");
  var _frequentWidgets = FrequentWidgets();
  final _formKey = GlobalKey<FormState>();

  bool _autoValidate;

  @override
  void initState() {
    super.initState();
    this._autoValidate = false;
    this._showDate = EmptyString;
    getInstructorInfo();
  }

  void getInstructorInfo() async {
    this._logger.info(" Pupil Id >>>> : ${appData.pupilId}");
    Instructor instructor =
        await Instructor(id: appData.instructorId).getInstructor();
    this._logger.info("Pupil Model >>>> : $instructor");
    nameController.text = instructor.name;
    addressController.text = instructor.address;
    phoneController.text = instructor.phoneNumber;
    drivingLicenseController.text = instructor.licenseNo;
    setState(() {
      if (instructor.dateOfBirth != null) {
        var format = DateFormat("MMM-dd-yyyy");
        _showDate = format.format(instructor.dateOfBirth);
      }
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
                      "$_showDate",
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
                                if (_validateInputs()) await _saveData();
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
    this._logger.info('Validate input called.');
    if (_formKey.currentState.validate()) {
      this._logger.info('${this._dateOfBirth}');
      if (this._dateOfBirth == null) {
        this._frequentWidgets.getSnackbar(
              message: 'Date of Birth is Required',
              context: context,
            );
        return false;
      }
      return true;
    } else {
      this._logger.info('Please check inputs.');
      return false;
    }
  }

  Future<void> _saveData() async {
    var instructor = Instructor(id: appData.instructorId);
    instructor.name = nameController.text;
    instructor.address = addressController.text;
    instructor.licenseNo = drivingLicenseController.text;
    instructor.dateOfBirth = this._dateOfBirth;
    var result = await instructor.update();
    String message = result
        ? 'Instructor updated successfully.'
        : 'Instructor update failed.';
    _frequentWidgets.getSnackbar(
      message: message,
      context: context,
    );
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

  DateTime _dateOfBirth = DateTime.now();
  String _showDate;
  Future<void> _selectDate(BuildContext context) async {
    this._dateOfBirth = await showDatePicker(
      context: context,
      initialDate: this._dateOfBirth,
      firstDate: DateTime(1900, 8),
      lastDate: DateTime(2101),
    );
    if (this._dateOfBirth != null) {
      setState(
        () {
          this._showDate = DateFormat('MMM-dd-yyyy').format(_dateOfBirth);
        },
      );
    }
    if (this._dateOfBirth == null && this._showDate.isNotEmpty) {
      this._dateOfBirth = DateFormat('MMM-dd-yyyy').parse(this._showDate);
      this._logger.info('${this._showDate} converted to ${this._dateOfBirth}');
    }
  }
}
