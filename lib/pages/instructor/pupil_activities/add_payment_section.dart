import 'package:adibook/core/app_data.dart';
import 'package:adibook/core/constants.dart';
import 'package:adibook/core/frequent_widgets.dart';
import 'package:adibook/core/type_conversion.dart';
import 'package:adibook/data/payment_manager.dart';
import 'package:adibook/models/payment.dart';
import 'package:flutter/material.dart';
import 'package:adibook/pages/validation.dart';
import 'package:logging/logging.dart';

class AddPaymentSection extends StatefulWidget {
  @override
  _AddPaymentSectionState createState() => _AddPaymentSectionState();
}

class _AddPaymentSectionState extends State<AddPaymentSection> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Logger _logger;
  bool _autoValidate;
  FrequentWidgets _frequentWidgets;
  DateTime _paymentDate;
  TextEditingController _amountController;
  PaymentType _selectedPaymentType;
  DateTime _dateOfPayment;
  _AddPaymentSectionState() {
    this._frequentWidgets = FrequentWidgets();
    this._paymentDate = DateTime.now();
    this._amountController = TextEditingController();
    this._logger = Logger(this.runtimeType.toString());
  }

  @override
  void initState() {
    super.initState();
    this._dateOfPayment = DateTime.now();
    this._autoValidate = false;
    _selectedPaymentType = PaymentType.Cash;
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
                                    onPressed:
                                        appData.userType == UserType.Instructor
                                            ? _selectDateOfpayment
                                            : null,
                                  ),
                                  Text(
                                    "Date Of Payment",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
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
                                  suffixIcon:
                                      Icon(Icons.star, color: Colors.red[600]),
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
                                      return new DropdownMenuItem<PaymentType>(
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
                                  if (appData.userType == UserType.Instructor)
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
    var _amount = int.parse(_amountController.text);
    Payment payment = new Payment(
        pupilId: appData.pupilId,
        instructorId: appData.instructorId,
        paymentDate: this._paymentDate,
        amount: _amount,
        type: this._selectedPaymentType);
    var message = await PaymentManager().createPayment(payment)
        ? 'Payment created successfully.'
        : 'Payment creation failed.';
    _frequentWidgets.getSnackbar(
      message: message,
      context: context,
    );
    _makeEmpty();
  }

  void _makeEmpty() {
    setState(() {
      this._dateOfPayment = DateTime.now();
      _amountController.text = null;
      _selectedPaymentType = PaymentType.Cash;
    });
  }

  // bool _validateInputs() {
  //   if (_paymentDate == null) {
  //     _frequentWidgets.getSnackbar(
  //       message: 'Date of Payment is Required',
  //       context: context,
  //     );
  //     return false;
  //   }
  //   this._logger.info('For validity ${_formKey.currentState.validate()}');
  //   return _formKey.currentState.validate();
  // }

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
}
