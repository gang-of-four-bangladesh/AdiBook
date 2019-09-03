import 'package:adibook/core/app_data.dart';
import 'package:adibook/core/constants.dart';
import 'package:adibook/core/frequent_widgets.dart';
import 'package:adibook/data/pupil_manager.dart';
import 'package:adibook/models/instructor.dart';
import 'package:adibook/models/pupil.dart';
import 'package:flutter/material.dart';
import 'package:adibook/pages/validation.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';

class AddPupilSection extends StatefulWidget {
  final UserType userType;
  AddPupilSection({this.userType});
  @override
  State<StatefulWidget> createState() {
    return AddPupilSectionstate();
  }
}

class AddPupilSectionstate extends State<AddPupilSection> {
  var _logger = Logger("pupil->profile");
  var _pupilManager = PupilManager();
  var _frequentWidgets = FrequentWidgets();
  final _formKey = GlobalKey<FormState>();

  var _selectedCountry = CountryWisePhoneCode.keys.first;
  bool _autoValidate;

  @override
  void initState() {
    super.initState();
    _showDate = '';
    this._autoValidate = false;
    switchOnEyeTest = false;
    switchOnTheoryRecord = false;
    switchOnPreviousExp = false;
    if (appData.userType == UserType.Pupil) getPupilInfo();
  }

  void getPupilInfo() async {
    this._logger.info(" Pupil Id >>>> : ${appData.pupilId}");
    Pupil pupil = await Pupil(id: appData.pupilId).populatePupilInfo();
    this._logger.info("Pupil Model >>>> : $pupil");
    nameController.text = pupil.name;
    addressController.text = pupil.address;
    phoneController.text = pupil.phoneNumber;
    drivingLicenseController.text = pupil.licenseNo;
    setState(() {
      var format = DateFormat("MMM-dd-yyyy");
      _showDate = format.format(pupil.dateOfBirth);
      switchOnEyeTest = pupil.eyeTest;
      switchOnTheoryRecord = pupil.theoryRecord;
      switchOnPreviousExp = pupil.previousExperience;
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
                      children: <Widget>[
                        //  Driving Type,
                        Container(
                          padding: EdgeInsets.only(left: 2.0, right: 2.0),
                          child: Row(
                            children: [
                              appData.userType == UserType.Pupil
                                  ? Column()
                                  : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        /*2*/
                                        DropdownButton<String>(
                                            items: CountryWisePhoneCode.keys
                                                .map((String country) {
                                              return DropdownMenuItem<String>(
                                                value: country,
                                                child: Text(country),
                                              );
                                            }).toList(),
                                            onChanged: (String value) {
                                              setState(() {
                                                _selectedCountry = value;
                                              });
                                            },
                                            value: _selectedCountry),
                                      ],
                                    ),
                              /*3*/
                              Flexible(
                                child: Container(
                                  padding: EdgeInsets.only(
                                      left: 2.0, right: 2.0, bottom: 5.0),
                                  child: TextFormField(
                                    enabled:
                                        appData.userType == UserType.Instructor
                                            ? true
                                            : false,
                                    controller: phoneController,
                                    keyboardType: TextInputType.phone,
                                    validator:
                                        appData.userType == UserType.Instructor
                                            ? validations.validatePhoneNumber
                                            : null,
                                    decoration: InputDecoration(
                                        suffixIcon:
                                            appData.userType == UserType.Pupil
                                                ? null
                                                : Icon(Icons.star,
                                                    color: Colors.red[600]),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.cyan[300]),
                                            borderRadius:
                                                BorderRadius.circular(8.0)),
                                        hintText: "Phone"),
                                  ),
                                ),
                              )
                            ],
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
                        value: switchOnEyeTest,
                        onChanged: (val) =>
                            setState(() => switchOnEyeTest = val),
                        activeColor: AppTheme.appThemeColor)
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
                        value: switchOnTheoryRecord,
                        onChanged: (val) =>
                            setState(() => switchOnTheoryRecord = val),
                        activeColor: AppTheme.appThemeColor)
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
                        value: switchOnPreviousExp,
                        onChanged: (val) =>
                            setState(() => switchOnPreviousExp = val),
                        activeColor: AppTheme.appThemeColor)
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
                                if (_validateInputs()) {
                                  if (appData.userType == UserType.Instructor)
                                    await _saveData();
                                  if (appData.userType == UserType.Pupil)
                                    await _updateData();
                                }
                              },
                              color: AppTheme.appThemeColor,
                              child: Text(
                                appData.userType == UserType.Pupil
                                    ? "Update"
                                    : "Save",
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
      if (this._dateOfBirth == null) {
        _frequentWidgets.getSnackbar(
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
      _dateOfBirth = DateTime.now();
      _showDate = null;
      switchOnEyeTest = false;
      switchOnTheoryRecord = false;
      switchOnPreviousExp = false;
    });
  }

  Future<void> _updateData() async {
    this._logger.info('Updating pupil information ${appData.pupilId}.');
    Pupil pupil = Pupil(id: appData.pupilId);
    pupil.name = nameController.text;
    pupil.phoneNumber = phoneController.text;
    pupil.address = addressController.text;
    pupil.licenseNo = drivingLicenseController.text;
    pupil.dateOfBirth = this._dateOfBirth;
    pupil.eyeTest = switchOnEyeTest;
    pupil.previousExperience = switchOnPreviousExp;
    pupil.theoryRecord = switchOnTheoryRecord;
    var result = await pupil.update();
    String message =
        result ? 'Pupil updated successfully.' : 'Pupil update failed.';
    _frequentWidgets.getSnackbar(
      message: message,
      context: context,
    );
  }

  Future<void> _saveData() async {
    var id = '${CountryWisePhoneCode[_selectedCountry]}${phoneController.text}';
    this._logger.info('Saving pupil information $id.');
    Pupil pupil = Pupil(id: id);
    pupil.name = nameController.text;
    pupil.phoneNumber =
        '${CountryWisePhoneCode[_selectedCountry]}${phoneController.text}';
    pupil.address = addressController.text;
    pupil.licenseNo = drivingLicenseController.text;
    pupil.dateOfBirth = this._dateOfBirth;
    pupil.eyeTest = switchOnEyeTest;
    pupil.previousExperience = switchOnPreviousExp;
    pupil.theoryRecord = switchOnTheoryRecord;
    var result = await pupil.add();
    var instructor = await Instructor(id: appData.instructorId).getInstructor();
    await _pupilManager.tagPupil(pupil, instructor);
    await _pupilManager.tagInstructor(pupil, instructor);
    String message = result
        ? 'Instructor updated successfully.'
        : 'Instructor update failed.';
    _frequentWidgets.getSnackbar(
      message: message,
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

  bool switchOnEyeTest = false;
  bool switchOnTheoryRecord = false;
  bool switchOnPreviousExp = false;
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
      initialDate: _dateOfBirth,
      firstDate: DateTime(1900, 8),
      lastDate: DateTime(2101),
    );
    if (this._dateOfBirth != null) {
      setState(
        () {
          this._showDate =
              new DateFormat('MMM-dd-yyyy').format(this._dateOfBirth);
        },
      );
    }
  }
}
