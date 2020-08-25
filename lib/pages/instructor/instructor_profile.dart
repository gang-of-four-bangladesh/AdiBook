import 'package:adibook/core/app_data.dart';
import 'package:adibook/core/constants.dart';
import 'package:adibook/core/frequent_widgets.dart';
import 'package:adibook/core/formatter.dart';
import 'package:adibook/models/instructor.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:adibook/pages/validation.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:logging/logging.dart';
import 'package:progress_dialog/progress_dialog.dart';

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
  TextEditingController nameController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();
  TextEditingController drivingLicenseController = new TextEditingController();
  TextEditingController dateOfBirthController = new TextEditingController();
  bool _autoValidate;
  DateTime dateOfBirth;
  ProgressDialog pr;

  @override
  void initState() {
    super.initState();
    pr = ProgressDialog(context,
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
          color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
    );
    this._autoValidate = false;
    getInstructorInfo();
  }

  void getInstructorInfo() async {
    Instructor instructor =
        await Instructor(id: appData.instructor.id).getInstructor();
    nameController.text = instructor.name;
    addressController.text = instructor.address;
    phoneController.text = instructor.phoneNumber;
    drivingLicenseController.text = instructor.licenseNo;
    this._logger.info('Instructor date of birth ${instructor.dateOfBirth}');
    if (!mounted) return;
    setState(() {
      this.dateOfBirthController.text = instructor.dateOfBirth == null
          ? TypeConversion.toDateDisplayFormat(DateTime.now())
          : TypeConversion.toDateDisplayFormat(instructor.dateOfBirth);
    });
  }

  @override
  Widget build(BuildContext context) {
    Validations validations = new Validations();
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
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
        onPressed: () async {
          if (_validateInputs()) await _saveData();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Form(
        key: _formKey,
        autovalidate: _autoValidate,
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(
                      top: 10.0, left: 20.0, right: 20.0, bottom: 10.0),
                  child: Wrap(
                    children: <Widget>[
                      TextFormField(
                        keyboardType: TextInputType.text,
                        controller: nameController,
                        validator: validations.validateText,
                        decoration: InputDecoration(
                            icon: Icon(EvaIcons.person),
                            suffixIcon: Icon(
                              Icons.star,
                              color: Colors.red[600],
                              size: 15,
                            ),
                            hintStyle: TextStyle(color: Colors.grey),
                            labelText: "Name"),
                      ),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        controller: addressController,
                        decoration: InputDecoration(
                            icon: Icon(EvaIcons.email), labelText: "Address"),
                      ),
                      TextFormField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        enabled: false,
                        decoration: InputDecoration(
                            icon: Icon(EvaIcons.phone), labelText: "Phone"),
                      ),
                      TextFormField(
                        controller: drivingLicenseController,
                        validator: validations.validateRequired,
                        decoration: InputDecoration(
                            icon: Icon(FontAwesomeIcons.book),
                            suffixIcon: Icon(
                              Icons.star,
                              color: Colors.red[600],
                              size: 15,
                            ),
                            labelText: "License number"),
                      ),
                      TextFormField(
                        controller: this.dateOfBirthController,
                        readOnly: true,
                        onTap: _selectDateOfBirth,
                        decoration: InputDecoration(
                            icon: Icon(FontAwesomeIcons.calendar),
                            labelText: "Birth Date"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _validateInputs() {
    this._logger.info('Validate input called.');
    if (_formKey.currentState.validate()) {
      return true;
    } else {
      this._logger.info('Please check inputs.');
      return false;
    }
  }

  Future<void> _saveData() async {
    await pr.show();
    var instructor = Instructor(id: appData.instructor.id);
    instructor.name = nameController.text;
    instructor.address = addressController.text;
    instructor.licenseNo = drivingLicenseController.text;
    instructor.phoneNumber = phoneController.text;
    instructor.dateOfBirth =
        TypeConversion.toDate(this.dateOfBirthController.text);
    var result = await instructor.update();
    String message = isNotNullOrEmpty(result)
        ? 'Instructor updated successfully.'
        : 'Instructor update failed.';
    pr.dismiss();
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
}
