import 'package:adibook/core/app_data.dart';
import 'package:adibook/core/constants.dart';
import 'package:adibook/core/frequent_widgets.dart';
import 'package:adibook/core/type_conversion.dart';
import 'package:adibook/models/payment.dart';
import 'package:flutter/material.dart';
import 'package:adibook/pages/validation.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  TextEditingController _amountController;
  PaymentType _selectedPaymentType;
  DateTime _dateOfPayment;
  String _paymentId;
  TextEditingController dateOfPaymentController = new TextEditingController();
  _AddPaymentSectionState() {
    this._frequentWidgets = FrequentWidgets();
    this._amountController = TextEditingController();
    this._logger = Logger(this.runtimeType.toString());
  }
  @override
  void initState() {
    super.initState();
    this.dateOfPaymentController.text = TypeConversion.toDateDisplayFormat(DateTime.now());
    this._autoValidate = false;
    _selectedPaymentType = PaymentType.Cash;
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
                    Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(bottom: 5.0),
                          child: TextFormField(
                            controller: this.dateOfPaymentController,
                            readOnly: true,
                            onTap: _selectDateOfBirth,
                            decoration: InputDecoration(
                                icon: Icon(FontAwesomeIcons.calendar),
                                labelText: "Payment Date"),
                          ),
                        ),
                      ],
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
                                  labelText: "Amount",
                                  suffixIcon:
                                      Icon(Icons.star, color: Colors.red[600]),
                                ),
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

  
  Future<void> _selectDateOfBirth() async {
    var displayDob = this.dateOfPaymentController.text == EmptyString
        ? DateTime.now()
        : TypeConversion.toDate(this.dateOfPaymentController.text);
    await DatePicker.showDatePicker(
      context,
      theme: DatePickerTheme(containerHeight: 210.0),
      showTitleActions: true,
      minTime: DateTime(1950, 1, 1),
      maxTime: DateTime(2022, 12, 31),
      currentTime: displayDob,
      onConfirm: (date) {
        setState(() {
          this.dateOfPaymentController.text = TypeConversion.toDateDisplayFormat(date);
        });
      },
    );
  }

  void _makeEmpty() {
    setState(() {
      this.dateOfPaymentController.text = TypeConversion.toDateDisplayFormat(DateTime.now());
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
}
