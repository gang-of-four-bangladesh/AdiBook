import 'package:adibook/core/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:flutter/services.dart';

class TypeConversion {
  static DateTime timeStampToDateTime(Timestamp timestamp) {
    if (timestamp == null) return null;
    return timestamp.toDate();
  }

  static String toDateTimeDisplayFormat(DateTime dateTime) {
    var format = DateFormat("MMM dd, yyyy hh:mm aaa");
    return format.format(dateTime);
  }

  static String toDateDisplayFormat(DateTime dateTime) {
    if (dateTime == null) return EmptyString;
    var format = DateFormat("MMM dd, yyyy");
    return format.format(dateTime);
  }

  static DateTime toDate(String dateTime) {
    if (dateTime == null) return null;
    var format = DateFormat("MMM dd, yyyy");
    return format.parse(dateTime);
  }

  static DateTime toDateTime(String dateTime) {
    if (dateTime == null) return null;
    var format = DateFormat("MMM dd, yyyy hh:mm aaa");
    return format.parse(dateTime);
  }

  static String toNumberFormat(DateTime dateTime) {
    var format = DateFormat("yMdHms");
    return format.format(dateTime);
  }
}

class PhoneNumber {
  static const MethodChannel _channel = const MethodChannel('phone_number');

  static Future<dynamic> parse(String string, {String region}) async {
    final args = {"string": string, "region": region};
    final result = await _channel.invokeMethod("parse", args);
    return result;
  }

  static Future<dynamic> parseList(List<String> strings,
      {String region}) async {
    final args = {"strings": strings, "region": region};
    final result = await _channel.invokeMethod("parse_list", args);
    return result;
  }

  static Future<dynamic> format(String string, String region) async {
    final args = {"string": string, "region": region};
    final result = await _channel.invokeMethod("format", args);
    return result;
  }
}
