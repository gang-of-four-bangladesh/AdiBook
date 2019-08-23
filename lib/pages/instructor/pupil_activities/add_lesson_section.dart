import 'dart:io';
import 'package:adibook/core/app_data.dart';
import 'package:adibook/core/constants.dart';
import 'package:adibook/models/lesson.dart';
import 'package:adibook/pages/validation.dart';
import 'package:adibook/utils/common_function.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class AddLessonSection extends StatefulWidget {
  @override
  _AddLessonSectionState createState() => _AddLessonSectionState();
}

class _AddLessonSectionState extends State<AddLessonSection> {
  CommonClass commonClass = CommonClass();
  // _formKey and _autoValidate
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  String _lessonDuration;
  String _diaryNotes;
  String _reportCard;
  bool switchOn_hasKnoledge;
  TextEditingController lessonDurationController = new TextEditingController();
  TextEditingController diaryNotesController = new TextEditingController();
  TextEditingController reportCardController = new TextEditingController();
  TripLocation _selectedPickupLocation;
  TripLocation _selectedDropOffLocation;
  LessionType _selectedlessionType;
  VehicleType _selectedVehicleType;

  //File Upload
  String _path;
  Map<String, String> _paths;
  String _extension;
  FileType _pickType;
  bool _multiPick = false;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  List<StorageUploadTask> _tasks = <StorageUploadTask>[];

  void openFileExplorer() async {
    try {
      _path = null;
      if (_multiPick) {
        _paths = await FilePicker.getMultiFilePath(
            type: _pickType, fileExtension: _extension);
      } else {
        _path = await FilePicker.getFilePath(
            type: _pickType, fileExtension: _extension);
      }
    } catch (e) {
      print("Unsupported operation" + e.toString());
    }
    if (!mounted) return;
  }

  uploadToFirebase() {
    if (_multiPick) {
      _paths.forEach((fileName, filePath) => {upload(fileName, filePath)});
    } else {
      String fileName = _path.split('/').last;
      String filePath = _path;
      upload(fileName, filePath);
    }
  }

  upload(fileName, filePath) {
    _extension = fileName.toString().split('.').last;
    StorageReference storageRef =
        FirebaseStorage.instance.ref().child(fileName);
    final StorageUploadTask uploadTask = storageRef.putFile(
      File(filePath),
      StorageMetadata(
        contentType: '$_pickType/$_extension',
      ),
    );
    setState(() {
      _tasks.add(uploadTask);
    });
  }

  Future<void> downloadFile(StorageReference ref) async {
    final String url = await ref.getDownloadURL();
    final http.Response downloadData = await http.get(url);
    final Directory systemTempDir = Directory.systemTemp;
    final File tempFile = File('${systemTempDir.path}/tmp.jpg');
    if (tempFile.existsSync()) {
      await tempFile.delete();
    }
    await tempFile.create();
    final StorageFileDownloadTask task = ref.writeToFile(tempFile);
    final int byteCount = (await task.future).totalByteCount;
    var bodyBytes = downloadData.bodyBytes;
    final String name = await ref.getName();
    final String path = await ref.getPath();
    print(
      'Success!\nDownloaded $name \nUrl: $url'
      '\npath: $path \nBytes Count :: $byteCount',
    );
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        backgroundColor: Colors.white,
        content: Image.memory(
          bodyBytes,
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _selectedPickupLocation = TripLocation.Home;
    _selectedDropOffLocation = TripLocation.Home;
    _selectedVehicleType = VehicleType.None;
    _selectedlessionType = LessionType.None;
    switchOn_hasKnoledge = false;
    _pickType = FileType.ANY;
  }

  @override
  Widget build(BuildContext context) {
    Validations validations = Validations();

    Future _theoryRecordonSwitchChanged(bool value) async {
      switchOn_hasKnoledge = value;
    }

    void _makeEmpty() {
      setState(() {
        _selectedPickupLocation = TripLocation.Home;
        _selectedDropOffLocation = TripLocation.Home;
        _selectedVehicleType = VehicleType.None;
        _selectedlessionType = LessionType.None;
        lessonDurationController.text = '';
        diaryNotesController.text = '';
        reportCardController.text = '';
        date_of_lesson = '';
        _show_date = '';
        switchOn_hasKnoledge = false;
      });
    }

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
                                  "$_show_date",
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
                              onSaved: (String value) {
                                _lessonDuration = value;
                              },
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
                        value: switchOn_hasKnoledge,
                        onChanged: (val) =>
                            setState(() => switchOn_hasKnoledge = val),
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
                                'File Upload',
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
                        icon: Icon(FontAwesomeIcons.fileUpload),
                        onPressed: () {
                          openFileExplorer();
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
                                  if (_validateInputs() == true)
                                    await _saveData();
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
    var _lessionDate = DateTime.parse(date_of_lesson.substring(6, 10) +
        '-' +
        date_of_lesson.substring(0, 2) +
        '-' +
        date_of_lesson.substring(3, 5) +
        ' 00:00:00.000');
    var _lessionDuration = int.parse(lessonDurationController.text);
    Lesson lesson = new Lesson(
      pupilId: appData.pupilId,
      instructorId: appData.instructorId,
      vehicleType: _selectedVehicleType,
      lessionType: _selectedlessionType,
      diaryNotes: diaryNotesController.text,
      reportCard: reportCardController.text,
      hasAcknowledged: switchOn_hasKnoledge,
      pickupLocation: _selectedPickupLocation,
      dropOffLocation: _selectedDropOffLocation,
      lessionDate: _lessionDate,
      lessionDuration: _lessionDuration,
    );
    await lesson.add() == true
        ? commonClass.getSnackbar('Lesson created successfully.', context)
        : commonClass.getSnackbar('Lesson creation failed.', context);
    _makeEmpty();
  }

  void _makeEmpty() {
    setState(() {
      lessonDurationController.text = '';
      diaryNotesController.text = '';
      reportCardController.text = '';
      date_of_lesson = '';
      _show_date = '';
      _selectedPickupLocation = TripLocation.Home;
      _selectedDropOffLocation = TripLocation.Home;
      _selectedVehicleType = VehicleType.None;
      _selectedlessionType = LessionType.None;
      switchOn_hasKnoledge = false;
    });
  }

  bool _validateInputs() {
    if (_formKey.currentState.validate()) {
//    If all data are correct then save data to out variables
      if (date_of_lesson == '') {
        commonClass.getSnackbar('Date of Lesson is Required', context);
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
  String date_of_lesson = '';
  String _show_date = '';
  TimeOfDay _show_time = new TimeOfDay.now();

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked =
        await showTimePicker(context: context, initialTime: _show_time);
    if (picked != null && picked != _show_time) {
      print('Time selected: ${_show_time.toString()}');
      setState(
        () {
          _show_time = picked;
          print(_show_time);
        },
      );
    }
  }

  Future<Null> _selectDate(BuildContext context) async {
    date_of_lesson = "";
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: date_of_lesson == ''
          ? selectedDate
          : DateTime.parse(date_of_lesson.substring(6, 10) +
              '-' +
              date_of_lesson.substring(3, 5) +
              '-' +
              date_of_lesson.substring(0, 2) +
              _show_time.toString()),
      firstDate: DateTime(1900, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      _selectTime(context);
      setState(
        () {
          date_of_lesson = new DateFormat('dd/MM/yyyy').format(picked);
          _show_date = new DateFormat('MMM-dd-yyyy HH:mm').format(picked);
        },
      );
    }
  }

  File file;
}
