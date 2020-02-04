import 'package:adibook/core/app_data.dart';
import 'package:adibook/core/constants.dart';
import 'package:adibook/core/frequent_widgets.dart';
import 'package:adibook/core/formatter.dart';
import 'package:adibook/core/widgets/dropdown_formfield.dart';
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
  PaymentMode _selectedPaymentMode;
  DateTime _dateOfPayment;
  String _pupilId;
  String _lessionId;
  String _paymentId;
  OperationMode _operationMode;
  TextEditingController dateOfPaymentController = TextEditingController();
  _AddPaymentSectionState() {
    this._frequentWidgets = FrequentWidgets();
    this._amountController = TextEditingController();
    this._logger = Logger(this.runtimeType.toString());
  }
  @override
  void initState() {
    super.initState();
    this.dateOfPaymentController.text =
        TypeConversion.toDateDisplayFormat(DateTime.now());
    this._autoValidate = false;
    _selectedPaymentMode = PaymentMode.Cash;
    this._pupilId = appData.contextualInfo[DataSharingKeys.PupilIdKey];
    this._lessionId = appData.contextualInfo[DataSharingKeys.LessonIdKey];    
    this._paymentId = appData.contextualInfo[DataSharingKeys.PaymentIdKey];
    this._operationMode =
        isNullOrEmpty(this._paymentId) ? OperationMode.New : OperationMode.Edit;
    if (this._operationMode == OperationMode.Edit) populatePaymentInfo(this._paymentId);
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
      this.dateOfPaymentController.text = TypeConversion.toDateDisplayFormat(payment.paymentDate);;
      this._selectedPaymentMode = payment.paymentType;
      this._paymentId = paymentId;
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
            if (appData.user.userType == UserType.Instructor) await _saveData();
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Form(
        key: _formKey,
        autovalidate: _autoValidate,
        child: Container(
          padding:
              EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0, bottom: 10.0),
          child: Wrap(
            children: <Widget>[
              TextFormField(
                controller: this.dateOfPaymentController,
                readOnly: true,
                onTap: _selectDateOfPayment,
                decoration: InputDecoration(
                    icon: Icon(FontAwesomeIcons.calendar),
                    suffixIcon: Icon(
                      Icons.star,
                      color: Colors.red[600],
                      size: 15,
                    ),
                    labelText: "Payment Date"),
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: _amountController,
                validator: validations.validateNumber,
                decoration: InputDecoration(
                  icon: Icon(FontAwesomeIcons.poundSign),
                  suffixIcon: Icon(
                    Icons.star,
                    color: Colors.red[600],
                    size: 15,
                  ),
                  labelText: "Amount",
                ),
              ),
              DropDownFormField(
                titleText: 'Payment Mode',
                hintText: 'Please choose one',
                required: true,
                value: this._selectedPaymentMode.index,
                onSaved: (value) {
                  setState(() {
                    this._selectedPaymentMode = PaymentMode.values[value];
                  });
                },
                onChanged: (value) {
                  setState(() {
                    this._selectedPaymentMode = PaymentMode.values[value];
                  });
                },
                dataSource: PaymentModeOptions,
                textField: 'display',
                valueField: 'value',
              ),
            ],
          ),
        ),
      ),
    );
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
        paymentType: this._selectedPaymentMode);
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

  Future<void> _selectDateOfPayment() async {
    _dateOfPayment = this.dateOfPaymentController.text == EmptyString
        ? DateTime.now()
        : TypeConversion.toDate(this.dateOfPaymentController.text);
    await DatePicker.showDatePicker(
      context,
      theme: DatePickerTheme(containerHeight: 210.0),
      showTitleActions: true,
      minTime: DateTime(1950, 1, 1),
      maxTime: DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day),
      currentTime: _dateOfPayment,
      onConfirm: (date) {
        setState(() {
          this.dateOfPaymentController.text =
              TypeConversion.toDateDisplayFormat(date);
        });
      },
    );
  }

  void _makeEmpty() {
    setState(() {
      this.dateOfPaymentController.text =
          TypeConversion.toDateDisplayFormat(DateTime.now());
      _amountController.text = EmptyString;
      _selectedPaymentMode = PaymentMode.Cash;
    });
  }

  bool _validateInputs() {
    _dateOfPayment = this.dateOfPaymentController.text == EmptyString
        ? DateTime.now()
        : TypeConversion.toDate(this.dateOfPaymentController.text);
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
