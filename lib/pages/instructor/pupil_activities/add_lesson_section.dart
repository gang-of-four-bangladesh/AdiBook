import 'package:adibook/core/app_data.dart';
import 'package:adibook/core/constants.dart';
import 'package:adibook/core/storage_upload.dart';
import 'package:adibook/models/lesson.dart';
import 'package:adibook/pages/validation.dart';
import 'package:adibook/utils/frequent_widgets.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';

class AddLessonSection extends StatefulWidget {
  @override
  _AddLessonSectionState createState() => _AddLessonSectionState();
}

class _AddLessonSectionState extends State<AddLessonSection> {
  FrequentWidgets frequentWidgets = FrequentWidgets();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  bool switchOnHasKnoledge;
  TextEditingController lessonDurationController = new TextEditingController();
  TextEditingController diaryNotesController = new TextEditingController();
  TextEditingController reportCardController = new TextEditingController();
  TripLocation _selectedPickupLocation;
  TripLocation _selectedDropOffLocation;
  LessionType _selectedlessionType;
  VehicleType _selectedVehicleType;
  String _attachedDocPath;

  @override
  void initState() {
    super.initState();
    _selectedPickupLocation = TripLocation.Home;
    _selectedDropOffLocation = TripLocation.Home;
    _selectedVehicleType = VehicleType.None;
    _selectedlessionType = LessionType.None;
    switchOnHasKnoledge = false;
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
                                              onPressed: () =>
                                                  _selectDate(context),
                                            ),
                                            Text(
                                              "Lesson Date",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
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

                          Container(
                            padding: EdgeInsets.only(bottom: 5.0),
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              controller: lessonDurationController,
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
                              controller: diaryNotesController,
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
                              controller: reportCardController,
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
                                'Has Knowledge',
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
                        value: switchOnHasKnoledge,
                        onChanged: (val) =>
                            setState(() => switchOnHasKnoledge = val),
                        activeColor: AppTheme.appThemeColor,
                      )
                    ],
                  ),
                ),
                //  file Upload,
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
                          setState(() {
                            this._attachedDocPath = _path;
                          });
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
                                  if (_validateInputs()) await _saveData();
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
    Logger _logger = Logger('lessons->datasave');
    var _lessionDate = DateTime.parse(dateOfLesson.substring(6, 10) +
        '-' +
        dateOfLesson.substring(0, 2) +
        '-' +
        dateOfLesson.substring(3, 5) +
        ' 00:00:00.000');

    var documentDownloadUrl = await storageUpload.uploadLessonFile(this._attachedDocPath);
    _logger.info('Download url $documentDownloadUrl;');
    var _lessionDuration = int.parse(lessonDurationController.text);
    print(_lessionDuration);
    Lesson lesson = new Lesson(
      pupilId: appData.pupilId,
      instructorId: appData.instructorId,
      vehicleType: _selectedVehicleType,
      lessionType: _selectedlessionType,
      diaryNotes: diaryNotesController.text,
      reportCard: reportCardController.text,
      documentDownloadUrl: documentDownloadUrl,
      hasAcknowledged: switchOnHasKnoledge,
      pickupLocation: _selectedPickupLocation,
      dropOffLocation: _selectedDropOffLocation,
      lessionDate: _lessionDate,
      lessionDuration: _lessionDuration,
    );
    await lesson.add()
        ? frequentWidgets.getSnackbar('Lesson created successfully.', context)
        : frequentWidgets.getSnackbar('Lesson creation failed.', context);
    _makeEmpty();
  }

  void _makeEmpty() {
    setState(() {
      lessonDurationController.text = '';
      diaryNotesController.text = '';
      reportCardController.text = '';
      dateOfLesson = '';
      showDate = '';
      _selectedPickupLocation = TripLocation.Home;
      _selectedDropOffLocation = TripLocation.Home;
      _selectedVehicleType = VehicleType.None;
      _selectedlessionType = LessionType.None;
      switchOnHasKnoledge = false;
      _attachedDocPath = null;
    });
  }

  bool _validateInputs() {
    if (_formKey.currentState.validate()) {
//    If all data are correct then save data to out variables
      if (dateOfLesson == '') {
        frequentWidgets.getSnackbar('Date of Lesson is Required', context);
        return false;
      }
      return true;
      //_formKey.currentState.save();
    } else {
//    If all data are not valid then start auto validation.
      return false;
    }
  }

  String enumValueToString(String enumvalue) {
    return enumvalue
        .toString()
        .substring(enumvalue.toString().indexOf('.') + 1);
  }

  DateTime selectedDate = DateTime.now();
  int getyear = 2019;
  String dateOfLesson = '';
  String showDate = '';
  TimeOfDay showTime = new TimeOfDay.now();

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked =
        await showTimePicker(context: context, initialTime: showTime);
    if (picked != null && picked != showTime) {
      print('Time selected: ${showTime.toString()}');
      setState(
        () {
          DateTime.parse(dateOfLesson.substring(6, 10) +
              '-' +
              dateOfLesson.substring(3, 5) +
              '-' +
              dateOfLesson.substring(0, 2) +
              showTime.toString());
          if (picked != null) {}
          print(showTime);
        },
      );
    }
  }

  Future<Null> _selectDate(BuildContext context) async {
    dateOfLesson = "";
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: dateOfLesson == ''
          ? selectedDate
          : DateTime.parse(dateOfLesson.substring(6, 10) +
              '-' +
              dateOfLesson.substring(3, 5) +
              '-' +
              dateOfLesson.substring(0, 2) +
              showTime.toString() +
              ':00.000'),
      firstDate: DateTime(1900, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      _selectTime(context);
      setState(
        () {
          dateOfLesson = new DateFormat('dd/MM/yyyy').format(picked);
          showDate = new DateFormat('MMM-dd-yyyy HH:mm').format(picked);
        },
      );
    }
  }
}
