import 'dart:core';
import 'package:adibook/core/constants.dart';
import 'package:adibook/core/type_conversion.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:sprintf/sprintf.dart';

class Payment {
  static const String DateKey = 'pod';
  static const String AmountKey = 'amn';
  static const String TypeKey = 'pot';
  static const String CreatedAtKey = 'cat';
  static const String UpdatedAtKey = 'uat';
  Logger _logger;
  Payment(
      {@required this.pupilId,
      @required this.instructorId,
      this.id,
      this.paymentDate,
      this.amount,
      this.type})
      : this.createdAt = null,
        this.updatedAt = null,
        this._logger = Logger('model->payment');

  String id;
  String pupilId;
  String instructorId;
  DateTime paymentDate;
  int amount;
  PaymentType type;
  DateTime createdAt;
  DateTime updatedAt;

  Map<String, dynamic> toJson() {
    return {
      // NameKey: name,
    };
  }

  Future<void> _toObject(DocumentSnapshot snapshot) async {
    this.id = snapshot.documentID;
    this.paymentDate = snapshot[Payment.DateKey];
    this.createdAt =
        TypeConversion.timeStampToDateTime(snapshot[Payment.CreatedAtKey]);
    this.updatedAt =
        TypeConversion.timeStampToDateTime(snapshot[Payment.UpdatedAtKey]);
  }

  Future<DocumentSnapshot> get() async {
    var path = sprintf(FirestorePath.PaymentsOfAPupilColection,
        [this.pupilId, this.instructorId]);
    return Firestore.instance.collection(path).document(this.id).get();
  }

  Future<Payment> getPayment() async {
    var lession = await this.get();
    if (!lession.exists) {
      this._logger.severe(
          'Lession ${this.id} for pupil ${this.pupilId} and instructor ${this.instructorId} does not exits!');
      return null;
    }
    await _toObject(lession);
    return this;
  }

  Future<bool> add() async {
    try {
      var path = sprintf(FirestorePath.PaymentsOfAPupilColection,
          [this.pupilId, this.instructorId]);
      this.createdAt = DateTime.now().toUtc();
      this.id = TypeConversion.toNumberFormat(this.createdAt);
      var json = this.toJson();
      json[CreatedAtKey] = this.createdAt;
      Firestore.instance.collection(path).document(this.id).setData(json);
      this._logger.info('Lesson created successfully with data $json.');
      return true;
    } catch (e) {
      this._logger.shout('Lesson creation failed. Reason $e');
      return false;
    }
  }

  Future<bool> update() async {
    try {
      var path = sprintf(FirestorePath.PaymentsOfAPupilColection,
          [this.pupilId, this.instructorId]);
      this.updatedAt = DateTime.now().toUtc();
      var json = this.toJson();
      json[UpdatedAtKey] = this.updatedAt;
      Firestore.instance.collection(path).document(this.id).updateData(json);
      this._logger.info('Lesson updated successfully with data $json.');
      return true;
    } catch (e) {
      this._logger.shout('Lesson update failed. Reason $e');
      return false;
    }
  }

  Future<void> delete() async {
    var path = sprintf(FirestorePath.PaymentsOfAPupilColection,
        [this.pupilId, this.instructorId]);
    return Firestore.instance.collection(path).document(this.id).delete();
  }
}
