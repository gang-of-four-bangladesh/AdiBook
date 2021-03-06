import 'package:adibook/core/app_data.dart';
import 'package:adibook/core/type_conversion.dart';
import 'package:adibook/models/lesson.dart';
import 'package:adibook/models/lesson_event.dart';
import 'package:adibook/models/pupil.dart';
import 'package:logging/logging.dart';
import 'package:intl/intl.dart';

class LessonManager {
  static const String LessonDescriptionKey = 'description';
  static const String LessonHasCompletedKey = 'isDone';
  final String _lessonIdDateFormat = "yyyyMM";
  Logger _logger;
  LessonManager() : this._logger = Logger('manger->lesson_manager');

  Future<bool> createLesson(Lesson lesson) async {
    if (!await lesson.add()) return false;
    var pupil = await Pupil(id: lesson.pupilId).getPupil();
    LessonEvent lessonEvent = LessonEvent(
      id: DateFormat(_lessonIdDateFormat).format(lesson.lessionDate),
      day: lesson.lessionDate.day.toString(),
      instructorId: lesson.instructorId,
      lessonAt: lesson.lessionDate,
      pupilName: pupil.name,
      pupilId: pupil.id,
    );
    var snap = await lessonEvent.get();
    if (snap.exists) {
      return await lessonEvent.update();
    }
    this._logger.info(
        'Lesson ${lesson.id} for pupil ${pupil.id} by instructor ${lesson.instructorId} creation complete including events.');
    return await lessonEvent.add();
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
      var id = DateFormat(_lessonIdDateFormat).format(DateTime(year, month));
      var lastDayOfMonth = DateTime(year, month + 1, 0).day;
      var snap =
          await LessonEvent(id: id, instructorId: appData.instructorId).get();
      if (snap.data == null) continue;
      for (var i = 1; i <= lastDayOfMonth; i++) {
        List<Map> events = new List();
        var data = snap.data[i.toString()];
        if (data == null) continue;
        var key = DateTime(year, month, i);
        for (var item in data) {
          var lessonTime = (TypeConversion.timeStampToDateTime(
                  item[LessonEvent.LessonTimeKey]))
              .toLocal();
          var difference = DateTime.now().difference(lessonTime).inSeconds;
          var eventDescription =
              'Lesson with ${item[LessonEvent.PupilNameKey]} at ${TypeConversion.toDisplayFormat(lessonTime)}.';
          events.add({
            LessonDescriptionKey: eventDescription,
            LessonHasCompletedKey: difference >= 0
          });
        }
        eventDetails.addAll({key: events});
      }
    }
    return eventDetails;
  }
}
