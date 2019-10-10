import 'package:adibook/core/app_data.dart';
import 'package:adibook/core/type_conversion.dart';
import 'package:adibook/models/lesson_event.dart';
import 'package:adibook/models/payment.dart';
import 'package:adibook/models/payment_event.dart';
import 'package:adibook/models/pupil.dart';
import 'package:logging/logging.dart';
import 'package:intl/intl.dart';

class PaymentManager {
  static const String PaymentDescriptionKey = 'description';
  static const String PaymentHasCompletedKey = 'isDone';
  final String _paymentIdDateFormat = "yyyyMM";
  Logger _logger;
  PaymentManager() : this._logger = Logger('manger->payment_manager');

  Future<bool> createPayment(Payment payment) async {
    if (!await payment.add()) return false;
    var pupil = await Pupil(id: payment.pupilId).getPupil();
    // PaymentEvent paymentEvent = PaymentEvent(
    //      id: DateFormat(_paymentIdDateFormat).format(payment.paymentDate),
    //   day: payment.paymentDate.day.toString(),
    //   instructorId: payment.instructorId,
    //   paymentAt: payment.paymentDate,
    //   pupilName: pupil.name,
    //   pupilId: pupil.id,
    // );
    // var snap = await paymentEvent.get();
    // if (snap.exists) {
    //   return await paymentEvent.update();
    // }
    this._logger.info(
        'Lesson ${payment.id} for pupil ${pupil.id} by instructor ${payment.instructorId} creation complete including events.');
    return await payment.add();
  }

  Future<Map> getLessonEvents({DateTime date}) async {
    Map eventDetails = {};
    var endDate = DateTime(date.year, date.month + 1, date.day);
    this._logger.info('Selected date $date, enddate $endDate');
    for (var startDate = DateTime(date.year, date.month - 1, date.day);
        endDate.difference(startDate).inDays >= -1;
        startDate =
            DateTime(startDate.year, startDate.month + 1, startDate.day)) {
      var month = startDate.month;
      var year = startDate.year;
      this._logger.info('Retreiving lesson events for date $startDate and difference ${endDate.difference(startDate).inDays}');
      var id = DateFormat(_paymentIdDateFormat).format(DateTime(year, month));
      var lastDayOfMonth = DateTime(year, month + 1, 0).day;
      var snap =
          await PaymentEvent(id: id, instructorId: appData.instructorId).get();
      if (snap.data == null) continue;
      for (var i = 1; i <= lastDayOfMonth; i++) {
        List<Map> events = new List();
        var data = snap.data[i.toString()];
        if (data == null) continue;
        var key = DateTime(year, month, i);
        for (var item in data) {
          var paymentTime = (TypeConversion.timeStampToDateTime(
                  item[PaymentEvent.PaymentTimeKey]))
              .toLocal();
          var difference = DateTime.now().difference(paymentTime).inSeconds;
          var eventDescription =
              'Lesson with ${item[LessonEvent.PupilNameKey]} at ${TypeConversion.toDisplayFormat(paymentTime)}.';
          events.add({
            PaymentDescriptionKey: eventDescription,
            PaymentHasCompletedKey: difference >= 0
          });
        }
        eventDetails.addAll({key: events});
      }
    }
    return eventDetails;
  }
}
