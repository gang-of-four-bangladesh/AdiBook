import 'package:adibook/core/app_data.dart';
import 'package:adibook/models/lesson.dart';
import 'package:adibook/models/pupil.dart';
import 'package:adibook/pages/validation.dart';
import 'package:adibook/utils/common_function.dart';
import 'package:adibook/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class AddLesson extends StatefulWidget {

  Map<String,dynamic> additionalData;
  AddLesson({@required this.additionalData});

  @override
  _AddLessonState createState() => _AddLessonState();
}

class _AddLessonState extends State<AddLesson> {
  final Map<String,dynamic> additionalData;
  _AddLessonState({this.additionalData});
  CommonClass commonClass = new CommonClass();
  // _formKey and _autoValidate
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
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
@override
void initState() {
    super.initState();
    _selectedPickupLocation= TripLocation.Home;
    _selectedDropOffLocation= TripLocation.Home;
    _selectedVehicleType = VehicleType.None;
    _selectedlessionType = LessionType.None;
    switchOn_hasKnoledge = false;
  }

  @override
  Widget build(BuildContext context) {
    Validations validations = Validations();

    Future _theoryRecordonSwitchChanged(bool value) async {
      switchOn_hasKnoledge = value;
    }

    void _makeEmpty() {
      setState(() {
        lessonDurationController.text = '';
        diaryNotesController.text = '';
        reportCardController.text = '';
        date_of_lesson = '';
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
                                                  {_selectDate(context)},
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
                                  "${date_of_lesson}",
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
                              validator: validations.validateText,
                              onSaved: (String value) {
                                _diaryNotes = value;
                              },
                              decoration: InputDecoration(
                                  suffixIcon:
                                      Icon(Icons.star, color: Colors.red[600]),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(
                                          commonClass.hexColor('#03D1BF'),
                                        ),
                                      ),
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
                                    value:_selectedPickupLocation,
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
                              validator: validations.validateText,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(
                                          commonClass.hexColor('#03D1BF'),
                                        ),
                                      ),
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
                              validator: validations.validateText,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(
                                          commonClass.hexColor('#03D1BF'),
                                        ),
                                      ),
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
                //  Eye test,
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
                        activeColor: Color(
                          commonClass.hexColor('#03D1BF'),
                        ),
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
                                onPressed: () async{
                                  Uuid lessonid = new Uuid();
                                  Lesson lesson = new Lesson(
                                      pupilId: "320a5c3f-15b6-4c9b-8328-42450dc630f",
                                      instructorId: "8qiL8dB7IpNAxheY5SrYjYekTiP2");
                                  lesson.id = lessonid.v4();
                                  lesson.lessionDate = DateTime.parse(
                                      date_of_lesson.substring(6, 10) +
                                          '-' +                                          
                                          date_of_lesson.substring(0, 2) +
                                          '-' +
                                          date_of_lesson.substring(3, 5) +
                                          ' 00:00:00.000');
                                  lesson.lessionDuration = int.parse(
                                      lessonDurationController.text);
                                  lesson.pickupLocation =
                                      _selectedPickupLocation;
                                  lesson.dropOffLocation =
                                      _selectedDropOffLocation;
                                  lesson.vehicleType = _selectedVehicleType;
                                  lesson.lessionType = _selectedlessionType;
                                  lesson.diaryNotes = diaryNotesController.text;
                                  lesson.reportCard = reportCardController.text;
                                  lesson.hasAcknowledged = switchOn_hasKnoledge;
                                  await 
                                  lesson.add();
                                },
                                //onPressed: () {},
                                //onPressed: _validateInputs,
                                // == true
                                //     ? () async {
                                //         print('called');
                                //         print('year: ' +
                                //             date_of_lesson.substring(6, 10));
                                //         print('day: ' +
                                //             date_of_lesson.substring(0, 2));
                                //         print(date_of_lesson);
                                //         print('month: ' +
                                //             date_of_lesson.substring(3, 5));
                                //         pupil.id = uuid.v4();
                                //         pupil.name = nameController.text;
                                //         pupil.phoneNumber = dropOffLocationController.text;
                                //         pupil.address = pickUpLocationController.text;
                                //         pupil.dateOfBirth = DateTime.parse(
                                //             date_of_lesson.substring(6, 10) +
                                //                 '-' +
                                //                 date_of_lesson.substring(3, 5) +
                                //                 '-' +
                                //                 date_of_lesson.substring(0, 2) +
                                //                 ' 00:00:00.000');
                                //         pupil.eyeTest = switchOn_diaryNotes;
                                //         pupil.previousExperience =
                                //             switchOn_prviouseExp;
                                //         pupil.theoryRecord =
                                //             switchOn_hasKnoledge;
                                //         await pupil.add();
                                //         var instructor = await Instructor(
                                //                 id: await UserManager
                                //                     .currentUserId)
                                //             .getInstructor();
                                //         await pupilManager.tagPupil(
                                //             pupil, instructor);
                                //         await pupilManager.tagInstructor(
                                //             pupil, instructor);
                                //         _makeEmpty();
                                //         commonClass.getSnackbar(
                                //             "Data save successfully", context);
                                //       }
                                //     : commonClass.getSnackbar(
                                //         "data failed to save !!!", context),
                                //onPressed: _validateInputs,
                                color: Color(
                                  commonClass.hexColor('#03D1BF'),
                                ),
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

  String enumValueToString(String enumvalue) {
    return enumvalue
        .toString()
        .substring(enumvalue.toString().indexOf('.') + 1);
  }

  DateTime selectedDate = DateTime.now();
  int getyear = 2019;
  String date_of_lesson = '';
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: date_of_lesson == ''
          ? selectedDate
          : DateTime.parse(date_of_lesson.substring(6, 10) +
              '-' +
              date_of_lesson.substring(3, 5) +
              '-' +
              date_of_lesson.substring(0, 2) +
              ' 00:00:00.000'),
      firstDate: DateTime(1900, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(
        () {
          date_of_lesson = new DateFormat('dd/MM/yyyy').format(picked);
        },
      );
    }
  }
}
