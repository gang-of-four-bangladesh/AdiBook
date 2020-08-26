import 'package:adibook/core/app_data.dart';
import 'package:adibook/core/constants.dart';
import 'package:adibook/core/frequent_widgets.dart';
import 'package:adibook/core/storage_upload.dart';
import 'package:adibook/core/formatter.dart';
import 'package:adibook/core/widgets/toogle_switch.dart';
import 'package:adibook/data/pupil_manager.dart';
import 'package:adibook/models/instructor.dart';
import 'package:adibook/models/pupil.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:adibook/pages/validation.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:io';
import 'package:logging/logging.dart';
import 'package:progress_dialog/progress_dialog.dart';

class AddPupilSection extends StatefulWidget {
  final UserType userType;
  AddPupilSection({this.userType});
  @override
  State<StatefulWidget> createState() {
    return AddPupilSectionstate();
  }
}

class AddPupilSectionstate extends State<AddPupilSection> {
  ProgressDialog pr;
  var _logger = Logger("pupil->profile");
  var _pupilManager = PupilManager();
  var _frequentWidgets = FrequentWidgets();
  final _formKey = GlobalKey<FormState>();
  bool _hadEyeTest = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController theoryRecordController = TextEditingController();
  TextEditingController dateOfBirthController = TextEditingController();
  TextEditingController eyeTestController = TextEditingController();
  TextEditingController previousExperienceController = TextEditingController();
  TextEditingController drivingLicenseController = TextEditingController();
  TextEditingController drivingLicenseNoController = TextEditingController();
  int countryCodeIndex;
  //var _selectedCountry = CountryWisePhoneCode.keys.first;
  String countryCode = "+44";
  bool _autoValidate;
  String _attachedDocPath;
  @override
  void initState() {
    super.initState();
    pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    pr.update(
      progress: 50.0,
      message: "Please wait...",
      progressWidget: Container(
          padding: EdgeInsets.all(8.0),
          child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(AppTheme.appThemeColor),
              strokeWidth: 5.0)),
      maxProgress: 100.0,
      progressTextStyle: TextStyle(
          color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.w600),
    );
    this._autoValidate = false;
    this._hadEyeTest = false;
    this.dateOfBirthController.text =
        TypeConversion.toDateDisplayFormat(DateTime.now());
    this.eyeTestController.text = 'NOT TESTED';
    if (appData.user.userType == UserType.Pupil) populatePupilInfo();
  }

  void populatePupilInfo() async {
    this._logger.info(" Pupil Id >>>> : ${appData.pupil.id}");
    Pupil pupil = await Pupil(id: appData.pupil.id).getPupil();
    this._logger.info("Pupil Model >>>> : $pupil");
    nameController.text = pupil.name == null ? EmptyString : pupil.name;
    addressController.text =
        pupil.address == null ? EmptyString : pupil.address;
    phoneController.text =
        pupil.phoneNumber == null ? EmptyString : pupil.phoneNumber;
    drivingLicenseNoController.text =
        pupil.licenseNo == null ? EmptyString : pupil.licenseNo;
    theoryRecordController.text =
        pupil.theoryRecord == null ? EmptyString : pupil.theoryRecord;
    previousExperienceController.text = pupil.previousExperience == null
        ? EmptyString
        : pupil.previousExperience;
    dateOfBirthController.text =
        TypeConversion.toDateDisplayFormat(pupil.dateOfBirth);
    this.eyeTestController.text = pupil.eyeTest ? "TESTED" : "NOT TESTED";
  }

  String phoneNumber;
  String phoneIsoCode;

  void onPhoneNumberChange(
      String number, String internationalizedPhoneNumber, String isoCode) {
    setState(() {
      phoneNumber = number;
      phoneIsoCode = isoCode;
    });
  }

  @override
  Widget build(BuildContext context) {
    var _screenWidth = MediaQuery.of(context).size.width;
    var _oneSixthWidth = _screenWidth / 8;
    var pageWidth = _screenWidth - (_oneSixthWidth * 2);
    Validations validations = new Validations();
    return Scaffold(
      floatingActionButton: getFloatButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Form(
        key: _formKey,
        autovalidate: _autoValidate,
        child: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(
                  top: 10.0, left: 20.0, right: 20.0, bottom: 10.0),
              child: Wrap(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      appData.user.userType == UserType.Instructor
                          ? ToggleSwitch(
                              minWidth: pageWidth / 2,
                              initialLabelIndex: 0,
                              activeBgColor: Colors.grey[100].withOpacity(0.6),
                              activeTextColor:
                                  Colors.grey[100].withOpacity(0.1),
                              inactiveBgColor:
                                  Colors.grey[100].withOpacity(0.1),
                              inactiveTextColor:
                                  Colors.grey[100].withOpacity(0.1),
                              labels: ['UK', 'BD'],
                              icons: [
                                FontAwesomeIcons.airbnb,
                                FontAwesomeIcons.flag
                              ],
                              onToggle: (index) async {
                                this.countryCode = index == 0 ? "+44" : "+88";
                                this._logger.info(
                                    'Selected Country Code ${this.countryCode}');
                              },
                            )
                          : Container(),
                      TextFormField(
                        enabled: appData.user.userType == UserType.Instructor,
                        keyboardType: TextInputType.text,
                        controller: nameController,
                        validator: validations.validateText,
                        decoration: InputDecoration(
                            icon: Icon(FontAwesomeIcons.userGraduate),
                            border: UnderlineInputBorder(),
                            suffixIcon: Icon(
                              Icons.star,
                              color: Colors.red[600],
                              size: 15,
                            ),
                            hintStyle: TextStyle(color: Colors.grey),
                            labelText: "Name"),
                      ),
                      TextFormField(
                        enabled: appData.user.userType == UserType.Instructor,
                        keyboardType: TextInputType.text,
                        controller: addressController,
                        decoration: InputDecoration(
                            icon: Icon(FontAwesomeIcons.addressCard),
                            hintStyle: TextStyle(color: Colors.grey),
                            labelText: "Address"),
                      ),
                      TextFormField(
                        enabled: appData.user.userType == UserType.Instructor,
                        keyboardType: TextInputType.text,
                        controller: theoryRecordController,
                        decoration: InputDecoration(
                            icon: Icon(FontAwesomeIcons.stickyNote),
                            hintStyle: TextStyle(color: Colors.grey),
                            labelText: "Theory Record"),
                      ),
                      TextFormField(
                        enabled: appData.user.userType == UserType.Instructor,
                        keyboardType: TextInputType.text,
                        controller: previousExperienceController,
                        decoration: InputDecoration(
                          labelText: "Previous Experience",
                          icon: Icon(FontAwesomeIcons.paperPlane),
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                      TextFormField(
                        enabled: appData.user.userType == UserType.Instructor,
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        validator: validations.validatePhoneNumber,
                        maxLength: appData.user.userType == UserType.Instructor
                            ? 11
                            : null,
                        decoration: InputDecoration(
                            icon: Icon(FontAwesomeIcons.phone),
                            suffixIcon: appData.user.userType == UserType.Pupil
                                ? null
                                : Icon(
                                    Icons.star,
                                    color: Colors.red[600],
                                    size: 15,
                                  ),
                            hintStyle: TextStyle(color: Colors.grey),
                            hintText: 'Please start with +44',
                            labelText: "Phone(+44)"),
                      ),
                      TextFormField(
                        enabled: appData.user.userType == UserType.Instructor,
                        controller: drivingLicenseNoController,
                        validator: validations.validateRequired,
                        decoration: InputDecoration(
                            icon: Icon(EvaIcons.book),
                            suffixIcon: Icon(
                              Icons.star,
                              color: Colors.red[600],
                              size: 15,
                            ),
                            hintStyle: TextStyle(color: Colors.grey),
                            labelText: "License number"),
                      ),
                      TextFormField(
                        controller: this.dateOfBirthController,
                        readOnly: true,
                        onTap: appData.user.userType == UserType.Instructor
                            ? _selectDateOfBirth
                            : null,
                        decoration: InputDecoration(
                            icon: Icon(FontAwesomeIcons.calendar),
                            labelText: "Birth Date"),
                      ),
                      TextFormField(
                        controller: this.eyeTestController,
                        readOnly: true,
                        onTap: appData.user.userType == UserType.Instructor
                            ? _onEyeTestChecked
                            : null,
                        decoration: InputDecoration(
                          icon: Icon(FontAwesomeIcons.eye),
                          labelText: "Eye Test",
                          suffixIcon:
                              appData.user.userType == UserType.Instructor
                                  ? Icon(
                                      this._hadEyeTest
                                          ? FontAwesomeIcons.toggleOn
                                          : FontAwesomeIcons.toggleOff,
                                      color: this._hadEyeTest
                                          ? Colors.green[600]
                                          : Colors.grey[600],
                                      size: 30,
                                    )
                                  : null,
                        ),
                      ),
                      TextFormField(
                        controller: this.drivingLicenseController,
                        readOnly: true,
                        onTap: _onDrivingLicenseUploadTap,
                        decoration: InputDecoration(
                            icon: Icon(FontAwesomeIcons.upload),
                            labelText: "Upload License"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onDrivingLicenseUploadTap() async {
    this.drivingLicenseController.text = await FilePicker.getFilePath(
        type: FileType.custom, allowedExtensions: ['pdf']);
  }

  bool _validateInputs() {
    if (_formKey.currentState.validate()) {
      //If all data are correct then save data to out variables
      if (this.dateOfBirthController.text == EmptyString) {
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

  Future<String> _addCountryCodeToPhoneNumber() async {
    if (this.phoneController.text.startsWith(this.countryCode))
      return this.phoneController.text;
    return "$countryCode" + "${this.phoneController.text}";
  }

  void _resetPageData() {
    setState(() {
      this.nameController.text = EmptyString;
      this.addressController.text = EmptyString;
      this.theoryRecordController.text = EmptyString;
      this.previousExperienceController.text = EmptyString;
      this.phoneController.text = EmptyString;
      this.drivingLicenseNoController.text = EmptyString;
      this.drivingLicenseController.text = EmptyString;
      this.dateOfBirthController.text =
          TypeConversion.toDateDisplayFormat(DateTime.now());
      this._hadEyeTest = false;
      this.eyeTestController.text = 'NOT TESTED';
    });
  }

  Future<void> _selectDateOfBirth() async {
    var displayDob = this.dateOfBirthController.text == EmptyString
        ? DateTime.now()
        : TypeConversion.toDate(this.dateOfBirthController.text);
    await DatePicker.showDatePicker(
      context,
      //theme: DatePickerTheme(containerHeight: 210.0),
      showTitleActions: true,
      minTime: DateTime(1950, 1, 1),
      maxTime: DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day),
      currentTime: displayDob,
      onConfirm: (date) {
        setState(() {
          this.dateOfBirthController.text =
              TypeConversion.toDateDisplayFormat(date);
        });
      },
    );
  }
  // Future<void> _updateData() async {
  //   this._logger.info('Updating pupil information ${appData.pupil.id}.');
  //   Pupil pupil = Pupil(id: appData.pupil.id);
  //   pupil.name = nameController.text;
  //   pupil.phoneNumber = phoneController.text;
  //   pupil.address = addressController.text;
  //   pupil.licenseNo = drivingLicenseController.text;
  //   pupil.dateOfBirth = this._dateOfBirth;
  //   pupil.eyeTest = _switchOnEyeTest;
  //   var result = await pupil.update();
  //   String message = isNotNullOrEmpty(result)
  //       ? 'Pupil updated successfully.'
  //       : 'Pupil update failed.';
  //   _frequentWidgets.getSnackbar(
  //     message: message,
  //     context: context,
  //   );
  // }

  Future<void> _saveData() async {
    if (!_validateInputs()) return;
    await pr.show();
    var id = await _addCountryCodeToPhoneNumber();
    StorageUpload storageUpload = StorageUpload();
    var documentDownloadUrl =
        await storageUpload.uploadDrivingLicenseFile(this._attachedDocPath);
    this._logger.info('Saving pupil information $id.');
    Pupil pupil = Pupil(id: id);
    pupil.name = nameController.text;
    pupil.phoneNumber = await _addCountryCodeToPhoneNumber();
    pupil.address = addressController.text;
    pupil.licenseNo = drivingLicenseNoController.text;
    pupil.dateOfBirth = TypeConversion.toDate(this.dateOfBirthController.text);
    pupil.eyeTest = _hadEyeTest;
    pupil.previousExperience = theoryRecordController.text;
    pupil.documentDownloadUrl = documentDownloadUrl;
    pupil.theoryRecord = previousExperienceController.text;
    var result = await pupil.add();
    var instructor =
        await Instructor(id: appData.instructor.id).getInstructor();
    await _pupilManager.tagPupil(pupil, instructor);
    await _pupilManager.tagInstructor(pupil, instructor);
    String message = isNotNullOrEmpty(result)
        ? 'Pupil created successfully.'
        : 'Pupil creation failed.';
    pr.hide();
    _frequentWidgets.getSnackbar(
      message: message,
      context: context,
    );
    _resetPageData();
  }

  Future<void> _onEyeTestChecked() async {
    setState(() {
      this._hadEyeTest = !this._hadEyeTest;
      this.eyeTestController.text = this._hadEyeTest ? "TESTED" : "NOT TESTED";
    });
  }

  File img;
  Future imagePickerCamera() async {
    img = await imagePickerCamera();
    setState(() {});
  }

  Future imagePickerGallary() async {
    img = await imagePickerGallary();
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

  Widget getFloatButton() {
    //if (appData.user.userType == UserType.Instructor)
    return FloatingActionButton.extended(
      elevation: 4.0,
      icon: const Icon(Icons.save),
      backgroundColor: AppTheme.appThemeColor,
      label: const Text(
        'Save',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16.0,
        ),
      ),
      onPressed: _saveData,
    );
  }
}
