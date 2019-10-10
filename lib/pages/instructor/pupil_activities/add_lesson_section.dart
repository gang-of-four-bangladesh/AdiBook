import 'dart:io';
import 'package:adibook/core/app_data.dart';
import 'package:adibook/core/constants.dart';
import 'package:adibook/core/frequent_widgets.dart';
import 'package:adibook/core/push_notification_manager.dart';
import 'package:adibook/core/storage_upload.dart';
import 'package:adibook/core/type_conversion.dart';
import 'package:adibook/data/lesson_manager.dart';
import 'package:adibook/models/instructor.dart';
import 'package:adibook/models/lesson.dart';
import 'package:adibook/pages/validation.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
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
  FrequentWidgets _frequentWidgets;
  bool _autoValidate = false;
  TripLocation _selectedPickupLocation;
  TripLocation _selectedDropOffLocation;
  LessionType _selectedlessionType;
  VehicleType _selectedVehicleType;
  String _attachedDocPath;
  DateTime _lessonDate;
  TimeOfDay _lessonTime;

  _AddLessonSectionState() {
    this._frequentWidgets = FrequentWidgets();
    this._lessonDurationController = TextEditingController();
    this._diaryNotesController = TextEditingController();
    this._reportCardController = TextEditingController();
    this._logger = Logger(this.runtimeType.toString());
    this._lessonDate = DateTime.now();
    this._lessonTime = TimeOfDay.now();
  }

  @override
  void initState() {
    super.initState();
    _selectedPickupLocation = TripLocation.Home;
    _selectedDropOffLocation = TripLocation.Home;
    _selectedVehicleType = VehicleType.None;
    _selectedlessionType = LessionType.None;
  }

  @override
  Widget build(BuildContext context) {
    Validations validations = Validations();
    return Scaffold(
      body: SingleChildScrollView(
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
                          //  Lesson Date,
                          Container(
                            padding: EdgeInsets.only(left: 2.0, right: 2.0),
                            child: Row(
                              children: [
                                Expanded(
                                  /*1*/
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      /*2*/
                                      Container(
                                        child: Row(
                                          children: <Widget>[
                                            IconButton(
                                              icon: Icon(Icons.date_range),
                                              onPressed: _selectDate,
                                            ),
                                            Text(
                                              "Lesson Date",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  '${TypeConversion.toDisplayFormat(this._lessonDate)}',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),

                          Container(
                            padding: EdgeInsets.only(bottom: 5.0),
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              controller: _lessonDurationController,
                              validator: validations.validateNumber,
                              decoration: InputDecoration(
                                  suffixIcon:
                                      Icon(Icons.star, color: Colors.red[600]),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: AppTheme.appThemeColor),
                                      borderRadius:
                                          new BorderRadius.circular(8.0)),
                                  hintText: "Lesson Duration(Minutes)"),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          //  Pickup TripLocation,
                          Container(
                            padding: EdgeInsets.only(left: 2.0, right: 2.0),
                            child: Row(
                              children: [
                                Expanded(
                                  /*1*/
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      /*2*/
                                      Container(
                                        child: Text(
                                          'Pickup Location',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                /*3*/
                                DropdownButton<TripLocation>(
                                    value: _selectedPickupLocation,
                                    onChanged: (TripLocation location) {
                                      setState(() {
                                        _selectedPickupLocation = location;
                                        print(_selectedPickupLocation);
                                      });
                                    },
                                    items: TripLocation.values
                                        .map((TripLocation location) {
                                      return new DropdownMenuItem<TripLocation>(
                                          value: location,
                                          child: new Text(enumValueToString(
                                              location.toString())));
                                    }).toList())
                              ],
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(left: 2.0, right: 2.0),
                            child: Row(
                              children: [
                                Expanded(
                                  /*1*/
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      /*2*/
                                      Container(
                                        child: Text(
                                          'DropOff Location',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                /*3*/
                                DropdownButton<TripLocation>(
                                    value: _selectedDropOffLocation,
                                    onChanged: (TripLocation location) {
                                      setState(() {
                                        _selectedDropOffLocation = location;
                                        print(_selectedDropOffLocation);
                                      });
                                    },
                                    items: TripLocation.values
                                        .map((TripLocation location) {
                                      return new DropdownMenuItem<TripLocation>(
                                          value: location,
                                          child: new Text(enumValueToString(
                                              location.toString())));
                                    }).toList())
                              ],
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          //  Driving Type,
                          Container(
                            padding: EdgeInsets.only(left: 5.0, right: 5.0),
                            child: Row(
                              children: [
                                Expanded(
                                  /*1*/
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      /*2*/
                                      Container(
                                        child: Text(
                                          'Vehicle Type',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                /*3*/
                                DropdownButton<VehicleType>(
                                    value: _selectedVehicleType,
                                    onChanged: (VehicleType vehicleType) {
                                      setState(() {
                                        _selectedVehicleType = vehicleType;
                                        print(_selectedVehicleType);
                                      });
                                    },
                                    items: VehicleType.values
                                        .map((VehicleType classType) {
                                      return new DropdownMenuItem<VehicleType>(
                                          value: classType,
                                          child: new Text(enumValueToString(
                                              classType.toString())));
                                    }).toList()),
                              ],
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
                                Expanded(
                                  /*1*/
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      /*2*/
                                      Container(
                                        child: Text(
                                          'Lesson Type',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                /*3*/
                                DropdownButton<LessionType>(
                                    value: _selectedlessionType,
                                    onChanged: (LessionType lessionType) {
                                      setState(() {
                                        _selectedlessionType = lessionType;
                                        print(_selectedlessionType);
                                      });
                                    },
                                    items: LessionType.values
                                        .map((LessionType lessionType) {
                                      return new DropdownMenuItem<LessionType>(
                                          value: lessionType,
                                          child: new Text(enumValueToString(
                                              lessionType.toString())));
                                    }).toList())
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
                              keyboardType: TextInputType.text,
                              controller: _diaryNotesController,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: AppTheme.appThemeColor),
                                      borderRadius:
                                          new BorderRadius.circular(8.0)),
                                  hintText: "Diary Notes(Optional)"),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(bottom: 5.0),
                            child: TextFormField(
                              keyboardType: TextInputType.multiline,
                              controller: _reportCardController,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: AppTheme.appThemeColor),
                                      borderRadius:
                                          new BorderRadius.circular(8.0)),
                                  hintText: "Report Card(Optional)"),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ), //  file Upload,
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
                                'File Upload (pdf)',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      /*3*/
                      IconButton(
                        icon: this._attachedDocPath == null
                            ? Icon(
                                FontAwesomeIcons.solidFilePdf,
                                color: AppTheme.appThemeColor,
                              )
                            : Icon(
                                FontAwesomeIcons.solidCheckSquare,
                                color: AppTheme.appThemeColor,
                              ),
                        onPressed: () async {
                          var _path = await FilePicker.getFilePath(
                              type: FileType.CUSTOM, fileExtension: "pdf");
                          File file = File(_path);
                          print(file.lengthSync());
                          file.lengthSync() <= 500000
                              ? setState(() {
                                  this._attachedDocPath = _path;
                                })
                              : _frequentWidgets.getSnackbar(
                                  message: "pdf file must be under 500kb",
                                  context: context,
                                  duration: 1);
                        },
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
                                onPressed: () async {
                                  if (_validateInputs()) {
                                    await _saveData();
                                    var instructor = await Instructor(id: appData.instructorId).getInstructor();
                                    await PushNotificationSender.send(
                                      userId: appData.pupilId,
                                      title: 'Driving Lesson Schedule',
                                      body: 'You have a driving class with ${instructor.name} on ${TypeConversion.toDisplayFormat(this._lessonDate)} for ${this._lessonTime} minutes.',
                                    );
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
      ),
    );
  }

  Future<void> _saveData() async {
    StorageUpload storageUpload = StorageUpload();
    var documentDownloadUrl =
        await storageUpload.uploadLessonFile(this._attachedDocPath);
    var _lessionDuration = int.parse(_lessonDurationController.text);
    Lesson lesson = new Lesson(
      pupilId: appData.pupilId,
      instructorId: appData.instructorId,
      vehicleType: this._selectedVehicleType,
      lessionType: this._selectedlessionType,
      diaryNotes: this._diaryNotesController.text,
      reportCard: this._reportCardController.text,
      documentDownloadUrl: documentDownloadUrl,
      pickupLocation: this._selectedPickupLocation,
      dropOffLocation: this._selectedDropOffLocation,
      lessionDate: this._lessonDate,
      lessionDuration: _lessionDuration,
    );
    var message = await LessonManager().createLesson(lesson)
        ? 'Lesson created successfully.'
        : 'Lesson creation failed.';
    _frequentWidgets.getSnackbar(
      message: message,
      context: context,
    );
    _makeEmpty();
  }

  void _makeEmpty() {
    setState(() {
      _lessonDurationController.text = null;
      _diaryNotesController.text = null;
      _reportCardController.text = null;
      _selectedPickupLocation = TripLocation.None;
      _selectedDropOffLocation = TripLocation.None;
      _selectedVehicleType = VehicleType.None;
      _selectedlessionType = LessionType.None;
      _attachedDocPath = null;
    });
  }

  bool _validateInputs() {
    if (_lessonDate == null) {
      _frequentWidgets.getSnackbar(
        message: 'Date of Lesson is Required',
        context: context,
      );
      return false;
    }
    this._logger.info('For validity ${_formKey.currentState.validate()}');
    return _formKey.currentState.validate();
  }

  String enumValueToString(String enumvalue) {
    return enumvalue
        .toString()
        .substring(enumvalue.toString().indexOf('.') + 1);
  }

  Future _selectDate() async {
    var selectedLessonDate = this._lessonDate;
    var selectedLessonTime = this._lessonTime;
    this._lessonDate = await showDatePicker(
      context: context,
      initialDate: this._lessonDate,
      firstDate: DateTime(1900, 8),
      lastDate: DateTime(2101),
    );
    this._logger.info('Selected lesson date $_lessonDate');
    if (this._lessonDate == null) {
      setState(() {
        this._lessonDate = selectedLessonDate;
        this._lessonTime = selectedLessonTime;
      });
      return;
    }

    this._lessonTime =
        await showTimePicker(context: context, initialTime: _lessonTime);
    this._logger.info('Selected lesson time $_lessonTime');

    if (this._lessonTime == null) _lessonTime = selectedLessonTime;

    setState(() {
      _lessonDate = DateTime(_lessonDate.year, _lessonDate.month,
          _lessonDate.day, _lessonTime.hour, _lessonTime.minute);
    });
    this._logger.info('Selected date time for lesson $_lessonDate');
  }
}
