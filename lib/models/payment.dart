import 'dart:core';
import 'package:adibook/core/constants.dart';
import 'package:adibook/core/formatter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:sprintf/sprintf.dart';

class Payment {
  static const String PaymentDateKey = 'pod';
  static const String AmountKey = 'amn';
  static const String PaymentTypeKey = 'pot';
  static const String CreatedAtKey = 'cat';
  static const String UpdatedAtKey = 'uat';
  Logger _logger;
  Payment(
      {@required this.pupilId,
      @required this.instructorId,
      this.id,
      this.paymentDate,
      this.amount,
      this.paymentType})
      : this.createdAt = null,
        this.updatedAt = null,
        this._logger = Logger('model->payment');

  String id;
  String pupilId;
  String instructorId;
  DateTime paymentDate;
  int amount;
  PaymentMode paymentType;
  DateTime createdAt;
  DateTime updatedAt;

  Map<String, dynamic> toJson() {
    var json = Map<String, dynamic>();
    if (isNotNullOrEmpty(paymentDate)) json[PaymentDateKey] = paymentDate;
    if (isNotNullOrEmpty(amount)) json[AmountKey] = amount;
    if (isNotNullOrEmpty(paymentType)) json[PaymentTypeKey] = paymentType.index;
    if (isNotNullOrEmpty(createdAt)) json[CreatedAtKey] = createdAt.toUtc();
    if (isNotNullOrEmpty(updatedAt)) json[UpdatedAtKey] = updatedAt.toUtc();
    return json;
  }

  Future<void> _toObject(DocumentSnapshot snapshot) async {
    this.id = snapshot.id;
    this.amount = snapshot.data()[Payment.AmountKey];
    this.paymentType = PaymentMode.values[snapshot.data()[Payment.PaymentTypeKey]];
    this.paymentDate = TypeConversion.timeStampToDateTime(snapshot.data()[Payment.PaymentDateKey]);
    this.createdAt =
        TypeConversion.timeStampToDateTime(snapshot.data()[Payment.CreatedAtKey]);
    this.updatedAt =
        TypeConversion.timeStampToDateTime(snapshot.data()[Payment.UpdatedAtKey]);
  }

  Future<DocumentSnapshot> get() async {
    var path = sprintf(FirestorePath.PaymentsOfAPupilColection,
        [this.pupilId, this.instructorId]);
    return FirebaseFirestore.instance.collection(path).doc(this.id).get();
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

  Future<Payment> add() async {
    try {
      var path = sprintf(FirestorePath.PaymentsOfAPupilColection,
          [this.pupilId, this.instructorId]);
      this.createdAt = DateTime.now();
      this.id = TypeConversion.toNumberFormat(this.createdAt);
      FirebaseFirestore.instance.collection(path).doc(this.id).set(this.toJson());
      this._logger.info('Payment created successfully.');
      return this;
    } catch (e) {
      this._logger.shout('Payment creation failed. Reason $e');
      return null;
    }
  }

  Future<bool> update() async {
    try {
      var path = sprintf(FirestorePath.PaymentsOfAPupilColection,
          [this.pupilId, this.instructorId]);
      this.updatedAt = DateTime.now();
      FirebaseFirestore.instance.collection(path).doc(this.id).update(this.toJson());
      this._logger.info('Lesson updated successfully.');
      return true;
    } catch (e) {
      this._logger.shout('Lesson update failed. Reason $e');
      return false;
    }
  }

  Future<void> delete() async {
    var path = sprintf(FirestorePath.PaymentsOfAPupilColection,
        [this.pupilId, this.instructorId]);
    return FirebaseFirestore.instance.collection(path).doc(this.id).delete();
  }
}
