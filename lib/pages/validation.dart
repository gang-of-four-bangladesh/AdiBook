class Validations {
    String validateRequired(String value) {
    if (value.isEmpty) return 'Required field';
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
    if (value.isEmpty) return 'Please choose a password.';
    return null;
  }

  String validateNumber(String value) {
    String pattern = r' (0-9]*$)';
    final RegExp regExp = new RegExp(pattern);
    if (value.length == 0) 
    {
        return "Mobile no is required";
    }
  }

String validateEmail(String value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(value))
    return 'Enter Valid Email';
  else
    return null;
}
  
}
