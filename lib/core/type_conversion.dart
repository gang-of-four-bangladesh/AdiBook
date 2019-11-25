import 'package:adibook/core/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class TypeConversion {
  static DateTime timeStampToDateTime(Timestamp timestamp) {
    if (timestamp == null) return null;
    return timestamp.toDate();
  }

  static String toDisplayFormat(DateTime dateTime) {
    var format = DateFormat("MMM dd, yyyy hh:mm aaa");
    return format.format(dateTime);
  }

  static String toDobFormat(DateTime dateTime) {
    if (dateTime == null) return EmptyString;
    var format = DateFormat("MMM dd, yyyy");
    return format.format(dateTime);
  }

  static DateTime stringToDobFormat(String dateTime) {
    if (dateTime == null) return null;
    var format = DateFormat("MMM dd, yyyy");
    return format.parse(dateTime);
  }

  static String toNumberFormat(DateTime dateTime) {
    var format = DateFormat("yMdHms");
    return format.format(dateTime);
  }
}
