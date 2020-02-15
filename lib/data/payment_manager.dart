import 'package:adibook/core/constants.dart';
import 'package:adibook/models/payment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sprintf/sprintf.dart';

class PaymentManager {
  Future<bool> createPayment(Payment payment) async {
    return isNullOrEmpty(await payment.add());
  }

  Future<void> deleteAllPaymentOfPupil(
      String pupilId, String instructorId) async {
    var path = sprintf(
        FirestorePath.PaymentsOfAPupilColection, [pupilId, instructorId]);
    return Firestore.instance.collection(path).getDocuments().then((snapshot) {
      for (DocumentSnapshot doc in snapshot.documents) {
        doc.reference.delete();
      }
    });
  }
}
