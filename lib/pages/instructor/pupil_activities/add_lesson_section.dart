import 'dart:io';
import 'package:adibook/core/app_data.dart';
import 'package:adibook/core/constants.dart';
import 'package:adibook/core/frequent_widgets.dart';
import 'package:adibook/core/push_notification_manager.dart';
import 'package:adibook/core/storage_upload.dart';
import 'package:adibook/core/type_conversion.dart';
import 'package:adibook/core/widgets/dropdown_formfield.dart';
import 'package:adibook/data/lesson_manager.dart';
import 'package:adibook/models/instructor.dart';
import 'package:adibook/models/lesson.dart';
import 'package:adibook/pages/validation.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:logging/logging.dart';

class AddLessonSection extends StatefulWidget {
  @override
  _AddLessonSectionState createState() => _AddLessonSectionState();
}

class _AddLessonSectionState extends State<AddLessonSection> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Logger _logger;
  TextEditingController _lessonDurationController;
  TextEditingController _diaryNotesController;
  TextEditingController _reportCardController;
  TextEditingController _lessonTimeController;
  TextEditingController _uploadLicenseController;
  FrequentWidgets _frequentWidgets;
  bool _autoValidate = false;
  TripLocation _selectedPickupLocation;
  TripLocation _selectedDropOffLocation;
  LessonType _selectedlessionType;
  VehicleType _selectedVehicleType;
  String _pupilId;
  String _lessionId;
  OperationMode _operationMode;

  _AddLessonSectionState() {
    this._frequentWidgets = FrequentWidgets();
    this._lessonDurationController = TextEditingController();
    this._diaryNotesController = TextEditingController();
    this._reportCardController = TextEditingController();
    this._lessonTimeController = TextEditingController();
    this._uploadLicenseController = TextEditingController();
    this._logger = Logger(this.runtimeType.toString());
  }

  @override
  void initState() {
    super.initState();
    _selectedPickupLocation = TripLocation.Home;
    _selectedDropOffLocation = TripLocation.Home;
    _selectedVehicleType = VehicleType.Automatic;
    _selectedlessionType = LessonType.Lession;
    this._pupilId = appData.contextualInfo[DataSharingKeys.PupilIdKey];
    this._lessionId = appData.contextualInfo[DataSharingKeys.LessonIdKey];
    this._operationMode =
        isNullOrEmpty(this._lessionId) ? OperationMode.New : OperationMode.Edit;
    if (this._operationMode == OperationMode.Edit) populateLessonInfo();
  }

  void populateLessonInfo() async {
    Lesson lesson = await Lesson(
            pupilId: this._pupilId,
            instructorId: appData.instructor.id,
            id: _lessionId)
        .getLession();
    this._logger.info("Leeson Model >>>> : $_lessionId");
    this._lessonDurationController.text = lesson.lessonDuration.toString();
    this._diaryNotesController.text = lesson.diaryNotes;
    this._reportCardController.text = lesson.reportCard;
    if (!mounted) return;
    setState(() {
      this._selectedPickupLocation = lesson.pickupLocation;
      this._selectedDropOffLocation = lesson.dropOffLocation;
      this._selectedVehicleType = lesson.vehicleType;
      this._selectedlessionType = lesson.lessonType;
    });
  }

  @override
  Widget build(BuildContext context) {
    Validations validations = Validations();
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
          if (_validateInputs()) {
            await _saveData();
            var instructor =
                await Instructor(id: appData.instructor.id).getInstructor();
            await PushNotificationSender.send(
              userId: this._pupilId,
              title: 'Driving Lesson Schedule',
              body:
                  'You have a driving class with ${instructor.name} on ${this._lessonTimeController.text} for ${this._lessonDurationController.text} minutes.',
            );
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SingleChildScrollView(
        child: Container(
          child: Form(
            key: _formKey,
            autovalidate: _autoValidate,
            child: Center(
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(
                        top: 10.0, left: 20.0, right: 20.0, bottom: 10.0),
                    child: Wrap(
                      children: <Widget>[
                        TextFormField(
                          controller: this._lessonTimeController,
                          validator: validations.validateRequired,
                          readOnly: true,
                          onTap: this._selectLessonTime,
                          decoration: InputDecoration(
                              icon: Icon(FontAwesomeIcons.calendar),
                              suffixIcon: Icon(
                                Icons.star,
                                color: Colors.red[600],
                                size: 15,
                              ),
                              labelText: "Lesson At"),
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          controller: _lessonDurationController,
                          validator: validations.validateNumber,
                          decoration: InputDecoration(
                            labelText: "Lesson Duration(Minutes)",
                            icon: Icon(FontAwesomeIcons.clock),
                            suffixIcon: Icon(
                              Icons.star,
                              color: Colors.red[600],
                              size: 15,
                            ),
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                        ),
                        DropDownFormField(
                          titleText: 'Pickup Location',
                          hintText: 'Please choose one',
                          required: true,
                          value: this._selectedPickupLocation.index,
                          onSaved: (value) {
                            setState(() {
                              this._selectedPickupLocation =
                                  TripLocation.values[value];
                            });
                          },
                          onChanged: (value) {
                            setState(() {
                              this._selectedPickupLocation =
                                  TripLocation.values[value];
                            });
                          },
                          dataSource: TripLocationOptions,
                          textField: 'display',
                          valueField: 'value',
                        ),
                        DropDownFormField(
                          titleText: 'Drop Off Location',
                          hintText: 'Please choose one',
                          required: true,
                          value: this._selectedDropOffLocation.index,
                          onSaved: (value) {
                            setState(() {
                              this._selectedDropOffLocation =
                                  TripLocation.values[value];
                            });
                          },
                          onChanged: (value) {
                            setState(() {
                              this._selectedDropOffLocation =
                                  TripLocation.values[value];
                            });
                          },
                          dataSource: TripLocationOptions,
                          textField: 'display',
                          valueField: 'value',
                        ),
                        DropDownFormField(
                          titleText: 'Vehicle Type',
                          hintText: 'Please choose one',
                          required: true,
                          value: this._selectedVehicleType.index,
                          onSaved: (value) {
                            setState(() {
                              this._selectedVehicleType =
                                  VehicleType.values[value];
                            });
                          },
                          onChanged: (value) {
                            setState(() {
                              this._selectedVehicleType =
                                  VehicleType.values[value];
                            });
                          },
                          dataSource: VehicleTypeOptions,
                          textField: 'display',
                          valueField: 'value',
                        ),
                        DropDownFormField(
                          titleText: 'Lesson Type',
                          hintText: 'Please choose one',
                          required: true,
                          value: this._selectedlessionType.index,
                          onSaved: (value) {
                            setState(() {
                              this._selectedlessionType =
                                  LessonType.values[value];
                            });
                          },
                          onChanged: (value) {
                            setState(() {
                              this._selectedlessionType =
                                  LessonType.values[value];
                            });
                          },
                          dataSource: LessonTypeOptions,
                          textField: 'display',
                          valueField: 'value',
                        ),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          controller: _diaryNotesController,
                          decoration: InputDecoration(
                              labelText: "Diary Notes",
                              icon: Icon(EvaIcons.book),
                              hintStyle: TextStyle(color: Colors.grey)),
                        ),
                        TextFormField(
                          keyboardType: TextInputType.multiline,
                          controller: _reportCardController,
                          decoration: InputDecoration(
                            labelText: "Report Card",
                            icon: Icon(Icons.report),
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                        ),
                        TextFormField(
                          controller: this._uploadLicenseController,
                          readOnly: true,
                          onTap: this._uploadLicense,
                          decoration: InputDecoration(
                              icon: Icon(FontAwesomeIcons.upload),
                              labelText: "Upload License"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _uploadLicense() async {
    this._uploadLicenseController.text = await FilePicker.getFilePath(
        type: FileType.CUSTOM, fileExtension: "pdf");
    File file = File(this._uploadLicenseController.text);
    if (file.lengthSync() > 30000)
      _frequentWidgets.getSnackbar(
          message: "File size exceed. Maximum size 30KB allowed.",
          context: context,
          duration: 1);
  }

  Future<void> _saveData() async {
    StorageUpload storageUpload = StorageUpload();
    var documentDownloadUrl = await storageUpload
        .uploadLessonFile(this._uploadLicenseController.text);
    var _lessionDuration = int.parse(_lessonDurationController.text);
    Lesson lesson = new Lesson(
      id: this._lessionId,
      pupilId: this._pupilId,
      instructorId: appData.instructor.id,
      vehicleType: this._selectedVehicleType,
      lessonType: this._selectedlessionType,
      diaryNotes: this._diaryNotesController.text,
      reportCard: this._reportCardController.text,
      documentDownloadUrl: documentDownloadUrl,
      pickupLocation: this._selectedPickupLocation,
      dropOffLocation: this._selectedDropOffLocation,
      lessonDuration: _lessionDuration,
    );
    String message;
    lesson.id == null
        ? message = isNotNullOrEmpty(await LessonManager().createLesson(lesson))
            ? 'Lesson created successfully.'
            : 'Lesson creation failed.'
        : message = isNotNullOrEmpty(await LessonManager().createLesson(lesson))
            ? 'Lesson updated successfully.'
            : 'Lesson updated failed.';
    _frequentWidgets.getSnackbar(
      message: message,
      context: context,
    );
    _makeEmpty();
  }

  void _makeEmpty() {
    setState(() {
      _lessonDurationController.text = EmptyString;
      _diaryNotesController.text = EmptyString;
      _reportCardController.text = EmptyString;
      _uploadLicenseController.text = EmptyString;
      _selectedPickupLocation = TripLocation.Home;
      _selectedDropOffLocation = TripLocation.Home;
      _selectedVehicleType = VehicleType.Automatic;
      _selectedlessionType = LessonType.Lession;
    });
  }

  bool _validateInputs() {
    return _formKey.currentState.validate();
  }

  String enumValueToString(String enumvalue) {
    return enumvalue
        .toString()
        .substring(enumvalue.toString().indexOf('.') + 1);
  }

  Future _selectLessonTime() async {
    if (this._operationMode == OperationMode.Edit) {
      await FrequentWidgets().dialogBox(context, 'Lesson Date',
          'Lesson date cannot be updated. You can delete this lesson and create a new one with the updated date.');
      return;
    }
    var displayLessonTime = this._lessonTimeController.text == EmptyString
        ? DateTime.now()
        : TypeConversion.toDateTime(this._lessonTimeController.text);
    await DatePicker.showDateTimePicker(
      context,
      theme: DatePickerTheme(containerHeight: 210.0),
      showTitleActions: true,
      minTime: DateTime(1950, 1, 1),
      maxTime: DateTime(2022, 12, 31),
      currentTime: displayLessonTime,
      onConfirm: (date) {
        setState(() {
          this._lessonTimeController.text =
              TypeConversion.toDateTimeDisplayFormat(date);
        });
      },
    );
  }
}
