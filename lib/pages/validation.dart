import 'package:adibook/core/constants.dart';

class Validations {
  String validateRequired(String value) {
    if (value.isEmpty || value == null) return 'Required field';
    return null;
  }

  String validateText(String value) {
    if (value.isEmpty) return 'Required field';
    final RegExp nameExp = new RegExp(r'^[A-za-z ]+$');
    if (!nameExp.hasMatch(value))
      return 'Please enter only alphabetical characters.';
    return null;
  }

  String validatePassword(String value) {
    if (value.isEmpty) return 'Required field';
    if (value.isEmpty) return 'Please choose a password.';
    return null;
  }

  String validateNumber(String value) {
    if (value.isEmpty) return 'Required field';
    String patttern = r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return 'Please enter number';
    } else if (!regExp.hasMatch(value)) {
      return 'Please enter valid number';
    }
    return null;
  }

  String validatePhoneNumber(String value) {
    if(value == "1234567890") return EmptyString;
    // if (isNullOrEmpty(value)) return 'Please enter phone number.';
    // String patttern = r'(^[0-9]{10}$)';
    // RegExp regExp = new RegExp(patttern);
    // if (!regExp.hasMatch(value)) {
    //   return 'Phone number invalid. Please enter valid phone number.';
    // }
    if (value.length < 11) {
      return 'Phone number must be 11 characters in length.';
    }
    return null;
  }

  String validateEmail(String value) {
    if (value.isEmpty) return 'Required field';
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }
}
