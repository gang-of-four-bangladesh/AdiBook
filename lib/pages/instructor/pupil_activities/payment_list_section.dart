import 'package:adibook/core/app_data.dart';
import 'package:adibook/core/constants.dart';
import 'package:adibook/core/frequent_widgets.dart';
import 'package:adibook/core/formatter.dart';
import 'package:adibook/data/pupil_manager.dart';
import 'package:adibook/models/payment.dart';
import 'package:adibook/pages/validation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:logging/logging.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class PaymentListSection extends StatefulWidget {
  @override
  PaymentListSectionState createState() => PaymentListSectionState();
}

class PaymentListSectionState extends State<PaymentListSection> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String paymentdialogBox = '';
  bool flagWarranty = false;
  FrequentWidgets _frequentWidgets = FrequentWidgets();
  Stream<QuerySnapshot> _querySnapshot;
  Logger _logger = Logger('page->payment_list');
  String _pupilId;
  String _paymentId;
  bool _autoValidate;
  TextEditingController _amountController;
  PaymentMode _selectedPaymentType;
  DateTime _dateOfPayment;

  PaymentListSectionState() {
    this._frequentWidgets = FrequentWidgets();
    this._amountController = TextEditingController();
    this._logger = Logger(this.runtimeType.toString());
  }
  @override
  void initState() {
    super.initState();
    this._dateOfPayment = DateTime.now();
    this._autoValidate = false;
    _selectedPaymentType = PaymentMode.Cash;
    this._pupilId = appData.contextualInfo[DataSharingKeys.PupilIdKey];
    this._logger.info('Payment in edit mode id ${this._paymentId}');
    if (appData.user.userType == UserType.Instructor) _loadPaymentsData();
    _loadPaymentsData();
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

  @override
  Widget build(BuildContext context) {
    _logger.fine('Loading pupil payments listing page.');
    return Container(
        child: Column(
      children: <Widget>[
        SizedBox(
          height: 15,
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
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
                        var paymentText =
                            'Paid £${document[Payment.AmountKey]} on ${format.format(TypeConversion.timeStampToDateTime(document[Payment.PaymentDateKey]))} by ' +
                                enumValueToString(PaymentMode
                                    .values[document[Payment.PaymentTypeKey]]
                                    .toString());
                        return Slidable(
                            actions: <Widget>[
                              IconSlideAction(
                                caption: 'Remove',
                                color: Colors.red,
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
                                  populatePaymentInfo(document.documentID);
                                  _asyncInputDialog(context);
                                },
                              ),
                            ],
                            actionPane: SlidableScrollActionPane(),
                            actionExtentRatio: 0.12,
                            child:
                                // Card(
                                //   // color: Colors.tealAccent[100],
                                //   child: Container(
                                //     decoration: BoxDecoration(
                                //         gradient: LinearGradient(colors: [
                                //       Colors.teal[300],
                                //       Colors.teal[200],
                                //       Colors.teal[100],
                                //       Colors.teal[50]
                                //     ])),
                                //   child: ListTile(
                                //     onTap: () {
                                //       print("clicked");
                                //     },
                                //     title: Text(
                                //       paymentText,
                                //       style: TextStyle(
                                //         fontWeight: FontWeight.bold,
                                //         fontSize: 16,
                                //       ),
                                //     ),
                                //   ),
                                // ),
                                // ),
                                GradientCard(
                              gradient: Gradients.coralCandyGradient,
                              child: ListTile(
                                onTap: () {
                                  print("clicked");
                                },
                                title: Text(
                                  paymentText,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ));
                      },
                    ).toList(),
                  );
              }
            },
          ),
        )
      ],
    ));
  }

  void populatePaymentInfo(String paymentId) async {
    Payment payment = await Payment(
            pupilId: this._pupilId,
            instructorId: appData.instructor.id,
            id: paymentId)
        .getPayment();
    this._logger.info("Payment Model >>>> : ${this._paymentId}");
    this._amountController.text = payment.amount.toString();
    if (!mounted) return;
    setState(() {
      this._dateOfPayment = payment.paymentDate;
      this._selectedPaymentType = payment.paymentType;
      this._paymentId = paymentId;
      Navigator.of(context).pop(paymentdialogBox);
      _asyncInputDialog(context);
    });
  }

  _asyncInputDialog(BuildContext context) {
    Validations validations = Validations();
    return showDialog(
      context: context,
      barrierDismissible:
          false, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Payment'),
          content: new Row(
            children: <Widget>[
              new Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    child: Form(
                      key: _formKey,
                      autovalidate: _autoValidate,
                      child: Center(
                        child: Column(children: <Widget>[
                          //  Date of Birth,
                          Container(
                            padding: EdgeInsets.only(left: 5.0, right: 5.0),
                            child: Row(
                              children: [
                                Column(
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
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                /*3*/
                                Text(
                                  "${TypeConversion.toDateDisplayFormat(this._dateOfPayment)}",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),

                          //textBoxSection,
                          Container(
                            padding: EdgeInsets.only(
                                top: 10.0,
                                left: 20.0,
                                right: 20.0,
                                bottom: 10.0),
                            child: Wrap(
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    TextFormField(
                                      keyboardType: TextInputType.number,
                                      controller: _amountController,
                                      validator: validations.validateNumber,
                                      decoration: InputDecoration(
                                          icon: Icon(
                                            FontAwesomeIcons.poundSign,
                                            size: 18,
                                          ),
                                          suffixIcon: Icon(
                                            Icons.star,
                                            color: Colors.red[600],
                                            size: 15,
                                          ),
                                          hintStyle:
                                              TextStyle(color: Colors.grey),
                                          hintText: "Amount"),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: <Widget>[
                                    //  Pickup TripLocation,
                                    Container(
                                      padding: EdgeInsets.only(
                                          left: 2.0, right: 2.0),
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
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          /*3*/
                                          DropdownButton<PaymentMode>(
                                              value: _selectedPaymentType,
                                              onChanged: (PaymentMode type) {
                                                setState(() {
                                                  _selectedPaymentType = type;
                                                  print(_selectedPaymentType);
                                                  Navigator.of(context)
                                                      .pop(paymentdialogBox);
                                                  _asyncInputDialog(context);
                                                });
                                              },
                                              items: PaymentMode.values
                                                  .map((PaymentMode type) {
                                                return new DropdownMenuItem<
                                                        PaymentMode>(
                                                    value: type,
                                                    child: new Text(
                                                        enumValueToString(
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
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      ButtonTheme(
                                        minWidth: 100.0,
                                        height: 40.0,
                                        child: RaisedButton(
                                          onPressed: () async {
                                            if (_validateInputs()) {
                                              if (appData.user.userType ==
                                                  UserType.Instructor)
                                                await _saveData();
                                              Navigator.of(context)
                                                  .pop(paymentdialogBox);
                                              _loadPaymentsData();
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
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      ButtonTheme(
                                        minWidth: 100.0,
                                        height: 40.0,
                                        child: RaisedButton(
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pop(paymentdialogBox);
                                          },
                                          color: AppTheme.appThemeColor,
                                          child: Text(
                                            "Cancel",
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
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  String enumValueToString(String enumvalue) {
    return enumvalue
        .toString()
        .substring(enumvalue.toString().indexOf('.') + 1);
  }

  Future<void> _deleteData(String paymentId) async {
    var pupilId = appData.contextualInfo[DataSharingKeys.PupilIdKey];
    Payment payment = new Payment(
        id: paymentId, pupilId: pupilId, instructorId: appData.instructor.id);
    String message = isNotNullOrEmpty(await payment.delete())
        ? 'Payment deleted failed.'
        : 'Payment deleted successfully.';
    _frequentWidgets.getSnackbar(
      message: message,
      context: context,
    );
    this._loadPaymentsData();
  }

  Future<void> _saveData() async {
    var _amount = int.parse(_amountController.text);
    var pupilId = appData.contextualInfo[DataSharingKeys.PupilIdKey];
    Payment payment = Payment(
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
      _selectedPaymentType = PaymentMode.Cash;
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
      Navigator.of(context).pop(paymentdialogBox);
      _asyncInputDialog(context);
    });
  }
}
