import 'package:adibook/core/app_data.dart';
import 'package:adibook/models/lesson.dart';
import 'package:adibook/models/lesson_event.dart';
import 'package:adibook/models/pupil.dart';
import 'package:logging/logging.dart';
import 'package:intl/intl.dart';

class LessonManager {
  Logger _logger;
  LessonManager() : this._logger = Logger('manger->lesson_manager');

  Future<bool> createLesson(Lesson lesson) async {
    if (!await lesson.add()) return false;
    var pupil = await Pupil(id: lesson.pupilId).getPupil();
    LessonEvent lessonEvent = LessonEvent(
      id: DateFormat("yyyy-MM").format(lesson.lessionDate),
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

  Future<Map> getLessonEvents({int year,int month}) async {
    var id = DateFormat("yyyy-MM").format(DateTime(year, month));
    var lastDayOfMonth = DateTime(year, month + 1, 0).day;
    this._logger.info('Last day of month $month is $lastDayOfMonth');
    var snap =
        await LessonEvent(id: id, instructorId: appData.instructorId).get();
    Map events = {};
    for (var i = 1; i < lastDayOfMonth; i++) {
      var data = snap.data[i.toString()];
      if (data == null) continue;
      var key = DateTime(year,month,i);
      var event = { key : data};
      events.addAll(event);
      //for (var item in data) {
      //  this._logger.info('Pupil ${item[LessonEvent.PupilNameKey]} have a meeting at ${item[LessonEvent.LessonTimeKey]}');
      //}
    }
    this._logger.info(events);
    return events;
  }
}
