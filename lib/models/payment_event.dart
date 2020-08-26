import 'package:adibook/core/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:sprintf/sprintf.dart';

class PaymentEvent {
  static const String PupilNameKey = 'pnm';
  static const String PaymentTimeKey = "ptm";
  static const String PupilReferenceKey = 'pref';
  static const String PupilReferenceTaggedAtKey = 'pRef';

  Logger _logger;
  PaymentEvent({
    @required this.id,
    @required this.instructorId,
    this.pupilId,
    this.day,
    this.pupilName,
    this.paymentAt,
  }) : this._logger = Logger('model->payment_event');
  String id;
  String day;
  String instructorId;
  String pupilName;
  DateTime paymentAt;
  String pupilId;

  Map<String, dynamic> _toJson() {
    var ref = FirebaseFirestore.instance
        .collection(FirestorePath.PupilCollection)
        .doc(this.pupilId);
    return {
      this.day: FieldValue.arrayUnion(
        [
          {
            PupilNameKey: this.pupilName,
            PaymentTimeKey: this.paymentAt,
            PupilReferenceTaggedAtKey: ref,
          }
        ],
      ),
    };
  }

  Future<DocumentSnapshot> get() async {
    var path = sprintf(FirestorePath.PaymentsOfAPupilColection,
        [this.instructorId, this.id]);
    return FirebaseFirestore.instance.collection(path).doc(this.id).get();
  }

  Future<bool> add() async {
    try {
      var path = sprintf(FirestorePath.PaymentsOfAPupilColection,
          [this.instructorId, this.id]);
      this._logger.info(path);
      var json = this._toJson();
      await FirebaseFirestore.instance.collection(path).doc(this.id).set(json);
      this._logger.info('Payment event created successfully with data $json.');
      return true;
    } catch (e) {
      this._logger.shout('Payment event creation failed. Reason $e');
      return false;
    }
  }

  Future<bool> update() async {
    try {
      var path = sprintf(FirestorePath.PaymentsOfAPupilColection,
          [this.instructorId, this.id]);
      this._logger.info(path);
      var json = this._toJson();
      await FirebaseFirestore.instance
          .collection(path)
          .doc(this.id)
          .update(json);
      this._logger.info('Payment event updated successfully with data $json.');
      return true;
    } catch (e) {
      this._logger.severe('Lesson event update failed. Reason $e');
      return false;
    }
  }

  Future<void> delete() async {
    var path = sprintf(FirestorePath.PaymentsOfAPupilColection,
        [this.instructorId, this.id]);
    var json = {
      this.day: FieldValue.arrayRemove(
        [
          {
            PupilNameKey: this.pupilName,
            PaymentTimeKey: this.paymentAt,
          }
        ],
      ),
    };
    await FirebaseFirestore.instance
        .collection(path)
        .doc(this.id)
        .update(json);
  }
}
