import 'package:adibook/core/app_data.dart';
import 'package:adibook/core/constants.dart';
import 'package:adibook/core/frequent_widgets.dart';
import 'package:adibook/core/type_conversion.dart';
import 'package:adibook/data/pupil_manager.dart';
import 'package:adibook/models/payment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:adibook/pages/validation.dart';
import 'package:logging/logging.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class AddPaymentSection extends StatefulWidget {
  @override
  _AddPaymentSectionState createState() => _AddPaymentSectionState();
}

class _AddPaymentSectionState extends State<AddPaymentSection> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Logger _logger;
  bool _autoValidate;
  FrequentWidgets _frequentWidgets;
  TextEditingController _amountController;
  PaymentType _selectedPaymentType;
  DateTime _dateOfPayment;
  String _pupilId;
  String _paymentId;
  Stream<QuerySnapshot> _querySnapshot;
  _AddPaymentSectionState() {
    this._frequentWidgets = FrequentWidgets();
    this._amountController = TextEditingController();
    this._logger = Logger(this.runtimeType.toString());
  }
  @override
  void initState() {
    super.initState();
    this._dateOfPayment = DateTime.now();
    this._autoValidate = false;
    _selectedPaymentType = PaymentType.Cash;
    this._pupilId = appData.contextualInfo[DataSharingKeys.PupilIdKey];
    this._paymentId = appData.contextualInfo[DataSharingKeys.PaymentIdKey];
    this._logger.info('payment in edit mode id ${this._paymentId}');
    //if (appData.user.userType == UserType.Instructor) populatePaymentInfo();
    this._loadPaymentsData();
  }

  void populatePaymentInfo() async {
    Payment payment = await Payment(
            pupilId: this._pupilId,
            instructorId: appData.instructor.id,
            id: this._paymentId)
        .getPayment();
    this._logger.info("Payment Model >>>> : ${this._paymentId}");
    this._amountController.text = payment.amount.toString();
    if (!mounted) return;
    setState(() {
      this._dateOfPayment = payment.paymentDate;
      this._selectedPaymentType = payment.paymentType;
    });
  }

  @override
  Widget build(BuildContext context) {
    Validations validations = Validations();
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          Container(
            child: Form(
              key: _formKey,
              autovalidate: _autoValidate,
              child: Center(
                child: Column(children: <Widget>[
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
                                          ? _selectDateOfpayment
                                          : null,
                                    ),
                                    Text(
                                      "Date Of Payment",
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
                          "${TypeConversion.toDobFormat(this._dateOfPayment)}",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),

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
                                keyboardType: TextInputType.number,
                                controller: _amountController,
                                validator: validations.validateNumber,
                                decoration: InputDecoration(
                                    suffixIcon: Icon(Icons.star,
                                        color: Colors.red[600]),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: AppTheme.appThemeColor),
                                        borderRadius:
                                            new BorderRadius.circular(8.0)),
                                    hintText: "Amount"),
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
                                            'Type',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  /*3*/
                                  DropdownButton<PaymentType>(
                                      value: _selectedPaymentType,
                                      onChanged: (PaymentType type) {
                                        setState(() {
                                          _selectedPaymentType = type;
                                          print(_selectedPaymentType);
                                        });
                                      },
                                      items: PaymentType.values
                                          .map((PaymentType type) {
                                        return new DropdownMenuItem<
                                                PaymentType>(
                                            value: type,
                                            child: new Text(enumValueToString(
                                                type.toString())));
                                      }).toList())
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ), //  file Upload,
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
            ), //_logger.fine('Loading pupil payments listing page.');
          ),
          Expanded(
              child: (StreamBuilder<QuerySnapshot>(
            stream: _querySnapshot,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              var format = DateFormat("EEEE dd MMMM");
              if (snapshot.hasError) return Text('Error: ${snapshot.error}');
              if (snapshot.data == null)
                return FrequentWidgets().getProgressBar();
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return FrequentWidgets().getProgressBar();
                default:
                  return ListView(
                    children: snapshot.data.documents.map(
                      (DocumentSnapshot document) {
                        return Slidable(
                            actions: <Widget>[
                              IconSlideAction(
                                caption: 'Remove',
                                color: AppTheme.appThemeColor,
                                icon: EvaIcons.trash,
                                onTap: () {
                                  showDialog<ConfirmAction>(
                                    context: context,
                                    barrierDismissible:
                                        false, // user must tap button for close dialog!
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("Delete"),
                                        content:
                                            Text("Do you want to delete ?"),
                                        actions: <Widget>[
                                          FlatButton(
                                            child: const Text('CANCEL'),
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pop(ConfirmAction.CANCEL);
                                            },
                                          ),
                                          FlatButton(
                                            child: const Text('ACCEPT'),
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pop(ConfirmAction.ACCEPT);
                                              _deleteData(document.documentID);
                                            },
                                          )
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                              IconSlideAction(
                                caption: 'Edit',
                                color: AppTheme.appThemeColor,
                                icon: EvaIcons.edit,
                                onTap: () {
                                  populatePaymentInfo();
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (context) => HomePage(
                                  //       sectionType:
                                  //           SectionType.InstructorActivityForPupil,
                                  //       userType: UserType.Instructor,
                                  //       defaultSectionIndex: 3,
                                  //       contextInfo: {
                                  //         DataSharingKeys.PaymentIdKey:
                                  //             document.documentID,
                                  //         DataSharingKeys.PupilIdKey: this._pupilId
                                  //       },
                                  //     ),
                                  //   ),
                                  // );
                                },
                              ),
                            ],
                            actionPane: SlidableScrollActionPane(),
                            actionExtentRatio: 0.12,
                            child: ListTile(
                              onTap: () {
                                print("clicked");
                              },
                              title: Container(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  children: <Widget>[
                                    //  Payment Date,
                                    Container(
                                      padding: EdgeInsets.only(
                                          left: 2.0, right: 2.0),
                                      child: Row(
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              /*2*/
                                              Container(
                                                child: Row(
                                                  children: <Widget>[
                                                    Column(
                                                      children: <Widget>[
                                                        Text(
                                                          ("Amount: " +
                                                              document[Payment
                                                                      .AmountKey]
                                                                  .toString() +
                                                              "\$"),
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 16),
                                                        ),
                                                        Text(
                                                          ("Payment Date: " +
                                                              format
                                                                  .format(TypeConversion
                                                                      .timeStampToDateTime(
                                                                          document[
                                                                              Payment.PaymentDateKey]))
                                                                  .toString()),
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 16),
                                                        ),
                                                        Text(
                                                          "Payment Type: " +
                                                              enumValueToString(PaymentType
                                                                  .values[int.parse(document[
                                                                          Payment
                                                                              .PaymentTypeKey]
                                                                      .toString())]
                                                                  .toString()),
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 16),
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ));
                      },
                    ).toList(),
                  );
              }
            },
          )))
        ],
      )),
    );
  }

  Future<void> _saveData() async {
    var _amount = int.parse(_amountController.text);
    var pupilId = appData.contextualInfo[DataSharingKeys.PupilIdKey];
    Payment payment = new Payment(
        id: this._paymentId,
        pupilId: pupilId,
        instructorId: appData.instructor.id,
        paymentDate: this._dateOfPayment,
        amount: _amount,
        paymentType: this._selectedPaymentType);
    String message;
    payment.id == null
        ? message = isNotNullOrEmpty(await payment.add())
            ? 'Payment created successfully.'
            : 'Payment creation failed.'
        : message = isNotNullOrEmpty(await payment.update())
            ? 'Payment Updated successfully.'
            : 'Payment update failed.';
    _frequentWidgets.getSnackbar(
      message: message,
      context: context,
    );
    _makeEmpty();
  }

  void _makeEmpty() {
    setState(() {
      this._dateOfPayment = DateTime.now();
      _amountController.text = EmptyString;
      _selectedPaymentType = PaymentType.Cash;
    });
  }

  bool _validateInputs() {
    if (_dateOfPayment == null) {
      _frequentWidgets.getSnackbar(
        message: 'Date of Payment is Required',
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

  Future<void> _selectDateOfpayment() async {
    var selectedDateOfPayment = this._dateOfPayment;
    this._dateOfPayment = await showDatePicker(
      context: context,
      initialDate: this._dateOfPayment,
      firstDate: DateTime(1900, 8),
      lastDate: DateTime(2101),
    );
    if (this._dateOfPayment == null)
      this._dateOfPayment = selectedDateOfPayment;
    setState(() {
      //This is for update the UI. Please before remove check twice.
      this._dateOfPayment = this._dateOfPayment;
    });
  }

  Future<void> _deleteData(String paymentId) async {
    var pupilId = appData.contextualInfo[DataSharingKeys.PupilIdKey];
    Payment payment = new Payment(
        id: paymentId, pupilId: pupilId, instructorId: appData.instructor.id);
    String message = isNotNullOrEmpty(await payment.delete())
        ? 'Payment deleted successfully.'
        : 'Payment deleted failed.';
    _frequentWidgets.getSnackbar(
      message: message,
      context: context,
    );
    this._loadPaymentsData();
  }

  void _loadPaymentsData() async {
    this._pupilId = appData.contextualInfo[DataSharingKeys.PupilIdKey];
    this._paymentId = appData.contextualInfo[DataSharingKeys.PaymentIdKey];
    if (isNullOrEmpty(this._pupilId)) return;
    if (!mounted) return;
    setState(() {
      _querySnapshot = PupilManager()
          .getPayments(
              instructorId: appData.instructor.id, pupilId: this._pupilId)
          .asStream();
    });
  }
}
