class Validations {
  String validateRequired(String value) {
    if (value.isEmpty) return 'Required field';
    final RegExp nameExp = new RegExp(r'^[A-za-z ]+$');
    if (!nameExp.hasMatch(value))
      return 'Please enter only alphabetical characters.';
    return null;
  }

  String validateEmail(String value) {
    if (value.isEmpty) return 'Email is required.';
    final RegExp nameExp = new RegExp(r'^\w+@[a-zA-Z_]+?\.[a-zA-Z]{2,3}$');
    if (!nameExp.hasMatch(value)) return 'Invalid email address';
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
}
