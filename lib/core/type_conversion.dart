import 'package:cloud_firestore/cloud_firestore.dart';

class TypeConversion {
  static DateTime timeStampToDateTime(Timestamp timestamp) {
    if (timestamp == null) return null;
    return timestamp.toDate();
  }
}
