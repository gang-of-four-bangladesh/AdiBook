import 'package:adibook/core/constants.dart';
import 'package:adibook/models/payment.dart';

class PaymentManager {
  Future<bool> createPayment(Payment payment) async {
   return isNullOrEmpty(await payment.add());
  }
}
