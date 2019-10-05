import 'package:adibook/core/app_data.dart';
import 'package:adibook/core/constants.dart';
import 'package:adibook/core/frequent_widgets.dart';
import 'package:adibook/core/type_conversion.dart';
import 'package:adibook/data/pupil_manager.dart';
import 'package:adibook/models/instructor.dart';
import 'package:adibook/models/pupil.dart';
import 'package:flutter/material.dart';
import 'package:adibook/pages/validation.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
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
  bool _switchOnEyeTest = false;
  bool _switchOnTheoryRecord = false;
  bool _switchOnPreviousExp = false;
  TextEditingController nameController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();
  TextEditingController drivingLicenseController = new TextEditingController();
  int countryCodeIndex;
  var _selectedCountry = CountryWisePhoneCode.keys.first;
  bool _autoValidate;
  DateTime _dateOfBirth;

  @override
  void initState() {
    super.initState();
    this._autoValidate = false;
    this._switchOnEyeTest = false;
    this._switchOnTheoryRecord = false;
    this._switchOnPreviousExp = false;
    this._dateOfBirth = DateTime.now();
    if (appData.userType == UserType.Pupil) populatePupilInfo();
  }

  void populatePupilInfo() async {
    this._logger.info(" Pupil Id >>>> : ${appData.pupilId}");
    Pupil pupil = await Pupil(id: appData.pupilId).getPupil();
    this._logger.info("Pupil Model >>>> : $pupil");
    nameController.text = pupil.name;
    addressController.text = pupil.address;
    phoneController.text = pupil.phoneNumber;
    drivingLicenseController.text = pupil.licenseNo;
    if (!mounted) return;
    setState(() {
      this._dateOfBirth = pupil.dateOfBirth;
      this._switchOnEyeTest = pupil.eyeTest;
      this._switchOnTheoryRecord = pupil.theoryRecord;
      this._switchOnPreviousExp = pupil.previousExperience;
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
                            enabled: appData.userType == UserType.Instructor
                                ? true
                                : false,
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
                            enabled: appData.userType == UserType.Instructor
                                ? true
                                : false,
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
                            enabled: appData.userType == UserType.Instructor
                                ? true
                                : false,
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
                                  onPressed:
                                      appData.userType == UserType.Instructor
                                          ? _selectDateOfBirth
                                          : null,
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
                      "${TypeConversion.toDobFormat(this._dateOfBirth)}",
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
                        value: _switchOnEyeTest,
                        onChanged: (val) => setState(() =>
                            appData.userType == UserType.Instructor
                                ? _switchOnEyeTest = val
                                : null),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                    Switch(
                      value: _switchOnTheoryRecord,
                      onChanged: (val) => setState(() =>
                          appData.userType == UserType.Instructor
                              ? _switchOnTheoryRecord = val
                              : null),
                      activeColor: AppTheme.appThemeColor,
                    ),
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
                      value: _switchOnPreviousExp,
                      onChanged: (val) => setState(() =>
                          appData.userType == UserType.Instructor
                              ? _switchOnPreviousExp = val
                              : null),
                      activeColor: AppTheme.appThemeColor,
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
                            child: appData.userType == UserType.Instructor
                                ? RaisedButton(
                                    onPressed: () async {
                                      if (_validateInputs()) {
                                        if (appData.userType ==
                                            UserType.Instructor)
                                          await _saveData();
                                      }
                                    },
                                    color: AppTheme.appThemeColor,
                                    child: Text(
                                      "Save",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0),
                                    ),
                                    shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(8.0),
                                    ),
                                  )
                                : Container(),
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

  void _resetPageData() {
    setState(() {
      this.nameController.text = EmptyString;
      this.addressController.text = EmptyString;
      this.phoneController.text = EmptyString;
      this.drivingLicenseController.text = EmptyString;
      this._dateOfBirth = DateTime.now();
      this._switchOnEyeTest = false;
      this._switchOnTheoryRecord = false;
      this._switchOnPreviousExp = false;
    });
  }

  // Future<void> _updateData() async {
  //   this._logger.info('Updating pupil information ${appData.pupilId}.');
  //   Pupil pupil = Pupil(id: appData.pupilId);
  //   pupil.name = nameController.text;
  //   pupil.phoneNumber = phoneController.text;
  //   pupil.address = addressController.text;
  //   pupil.licenseNo = drivingLicenseController.text;
  //   pupil.dateOfBirth = this._dateOfBirth;
  //   pupil.eyeTest = _switchOnEyeTest;
  //   pupil.previousExperience = _switchOnPreviousExp;
  //   pupil.theoryRecord = _switchOnTheoryRecord;
  //   var result = await pupil.update();
  //   String message =
  //       result ? 'Pupil updated successfully.' : 'Pupil update failed.';
  //   _frequentWidgets.getSnackbar(
  //     message: message,
  //     context: context,
  //   );
  // }

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
    pupil.eyeTest = _switchOnEyeTest;
    pupil.previousExperience = _switchOnPreviousExp;
    pupil.theoryRecord = _switchOnTheoryRecord;
    var result = await pupil.add();
    var instructor = await Instructor(id: appData.instructorId).getInstructor();
    await _pupilManager.tagPupil(pupil, instructor);
    await _pupilManager.tagInstructor(pupil, instructor);
    String message =
        result ? 'Pupil created successfully.' : 'Pupil creation failed.';
    _frequentWidgets.getSnackbar(
      message: message,
      context: context,
    );
    _resetPageData();
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

  Future<void> _selectDateOfBirth() async {
    var selectedDateOfBirth = this._dateOfBirth;
    this._dateOfBirth = await showDatePicker(
      context: context,
      initialDate: this._dateOfBirth,
      firstDate: DateTime(1900, 8),
      lastDate: DateTime(2101),
    );
    if (this._dateOfBirth == null) this._dateOfBirth = selectedDateOfBirth;
    setState(() {
      //This is for update the UI. Please before remove check twice.
      this._dateOfBirth = this._dateOfBirth;
    });
  }
}
