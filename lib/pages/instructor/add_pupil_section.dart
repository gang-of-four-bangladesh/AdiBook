import 'package:adibook/core/app_data.dart';
import 'package:adibook/core/constants.dart';
import 'package:adibook/core/frequent_widgets.dart';
import 'package:adibook/core/storage_upload.dart';
import 'package:adibook/core/type_conversion.dart';
import 'package:adibook/data/pupil_manager.dart';
import 'package:adibook/models/instructor.dart';
import 'package:adibook/models/pupil.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:adibook/pages/validation.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  TextEditingController nameController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();
  TextEditingController theoryRecordController = new TextEditingController();
  TextEditingController previousExperienceController =
      new TextEditingController();
  TextEditingController drivingLicenseController = new TextEditingController();
  int countryCodeIndex;
  var _selectedCountry = CountryWisePhoneCode.keys.first;
  bool _autoValidate;
  DateTime _dateOfBirth;
  String _attachedDocPath;
  String _drivingLicenseImageUrl;
  @override
  void initState() {
    super.initState();
    this._autoValidate = false;
    this._switchOnEyeTest = false;
    this._dateOfBirth = DateTime.now();
    if (appData.user.userType == UserType.Pupil) populatePupilInfo();
  }

  void populatePupilInfo() async {
    this._logger.info(" Pupil Id >>>> : ${appData.pupil.id}");
    Pupil pupil = await Pupil(id: appData.pupil.id).getPupil();
    this._logger.info("Pupil Model >>>> : $pupil");
    nameController.text = pupil.name;
    addressController.text = pupil.address;
    phoneController.text = pupil.phoneNumber;
    drivingLicenseController.text = pupil.licenseNo;
    theoryRecordController.text = pupil.theoryRecord;
    _drivingLicenseImageUrl = pupil.documentDownloadUrl;
    previousExperienceController.text = pupil.previousExperience;
    if (!mounted) return;
    setState(() {
      this._dateOfBirth = pupil.dateOfBirth;
      this._switchOnEyeTest = pupil.eyeTest;
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
                            enabled:
                                appData.user.userType == UserType.Instructor
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
                            enabled:
                                appData.user.userType == UserType.Instructor
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
                        Container(
                          padding: EdgeInsets.only(bottom: 5.0),
                          child: TextFormField(
                            enabled:
                                appData.user.userType == UserType.Instructor
                                    ? true
                                    : false,
                            keyboardType: TextInputType.text,
                            controller: theoryRecordController,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.cyan[300]),
                                    borderRadius: BorderRadius.circular(8.0)),
                                hintText: "Theory Record"),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(bottom: 5.0),
                          child: TextFormField(
                            enabled:
                                appData.user.userType == UserType.Instructor
                                    ? true
                                    : false,
                            keyboardType: TextInputType.text,
                            controller: previousExperienceController,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.cyan[300]),
                                    borderRadius: BorderRadius.circular(8.0)),
                                hintText: "Previous Experience"),
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
                              appData.user.userType == UserType.Pupil
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
                                    enabled: appData.user.userType ==
                                            UserType.Instructor
                                        ? true
                                        : false,
                                    controller: phoneController,
                                    keyboardType: TextInputType.phone,
                                    validator: appData.user.userType ==
                                            UserType.Instructor
                                        ? validations.validatePhoneNumber
                                        : null,
                                    decoration: InputDecoration(
                                        suffixIcon: appData.user.userType ==
                                                UserType.Pupil
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
                            enabled:
                                appData.user.userType == UserType.Instructor
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
                                  onPressed: appData.user.userType ==
                                          UserType.Instructor
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
                            appData.user.userType == UserType.Instructor
                                ? _switchOnEyeTest = val
                                : null),
                        activeColor: AppTheme.appThemeColor)
                  ],
                ),
              ),

              //Driving License image upload
              Container(
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                child: Row(
                  children: [
                    Expanded(
                      /*1*/
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /*2*/ Container(
                            child: Text(
                              this._drivingLicenseImageUrl == null
                                  ? 'Upload Driving License Picture'
                                  : 'Driving License Picture',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    /*3*/
                    _drivingLicenseImageUrl == null
                        ? IconButton(
                            icon: this._attachedDocPath == null
                                ? Icon(
                                    FontAwesomeIcons.solidFileImage,
                                    color: AppTheme.appThemeColor,
                                  )
                                : Icon(
                                    FontAwesomeIcons.solidCheckSquare,
                                    color: AppTheme.appThemeColor,
                                  ),
                            onPressed: () async {
                              var _path = EmptyString;
                              _path = await FilePicker.getFilePath(
                                  type: FileType.IMAGE);
                              File file = File(_path);
                              print(file.lengthSync());
                              file.lengthSync() <= 500000
                                  ? setState(() {
                                      this._attachedDocPath = _path;
                                    })
                                  : _frequentWidgets.getSnackbar(
                                      message: "Image must be under 500kb",
                                      context: context,
                                      duration: 1);
                            },
                          )
                        : GestureDetector(
                            child: Hero(
                              tag: 'imageHero',
                              child: Image.network(
                                this._drivingLicenseImageUrl,
                                width: 50,
                                height: 50,
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return DetailScreen(
                                        downloadUrl:
                                            this._drivingLicenseImageUrl);
                                  },
                                ),
                              );
                            },
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
                            child: appData.user.userType == UserType.Instructor
                                ? RaisedButton(
                                    onPressed: () async {
                                      if (_validateInputs()) {
                                        if (appData.user.userType ==
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
      this.theoryRecordController.text = EmptyString;
      this.previousExperienceController.text = EmptyString;
      this.phoneController.text = EmptyString;
      this.drivingLicenseController.text = EmptyString;
      this._dateOfBirth = DateTime.now();
      this._switchOnEyeTest = false;
    });
  }

  Future<void> _updateData() async {
    this._logger.info('Updating pupil information ${appData.pupil.id}.');
    Pupil pupil = Pupil(id: appData.pupil.id);
    pupil.name = nameController.text;
    pupil.phoneNumber = phoneController.text;
    pupil.address = addressController.text;
    pupil.licenseNo = drivingLicenseController.text;
    pupil.dateOfBirth = this._dateOfBirth;
    pupil.eyeTest = _switchOnEyeTest;
    var result = await pupil.update();
    String message = isNotNullOrEmpty(result)
        ? 'Pupil updated successfully.'
        : 'Pupil update failed.';
    _frequentWidgets.getSnackbar(
      message: message,
      context: context,
    );
  }

  Future<void> _saveData() async {
    var id = '${CountryWisePhoneCode[_selectedCountry]}${phoneController.text}';
    StorageUpload storageUpload = StorageUpload();
    var documentDownloadUrl =
        await storageUpload.uploadDrivingLicenseFile(this._attachedDocPath);
    this._logger.info('Saving pupil information $id.');
    Pupil pupil = Pupil(id: id);
    pupil.name = nameController.text;
    pupil.phoneNumber =
        '${CountryWisePhoneCode[_selectedCountry]}${phoneController.text}';
    pupil.address = addressController.text;
    pupil.licenseNo = drivingLicenseController.text;
    pupil.dateOfBirth = this._dateOfBirth;
    pupil.eyeTest = _switchOnEyeTest;
    pupil.previousExperience = theoryRecordController.text;
    pupil.documentDownloadUrl = documentDownloadUrl;
    pupil.theoryRecord = previousExperienceController.text;
    var result = await pupil.add();
    var instructor =
        await Instructor(id: appData.instructor.id).getInstructor();
    await _pupilManager.tagPupil(pupil, instructor);
    await _pupilManager.tagInstructor(pupil, instructor);
    String message =
        isNotNullOrEmpty(result) ? 'Pupil created successfully.' : 'Pupil creation failed.';
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
