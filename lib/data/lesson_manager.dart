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
    var format = DateFormat("yMMM");
    var id = format.format(lesson.lessionDate);
    var pupil = await Pupil(id: lesson.pupilId).getPupil();
    LessonEvent lessonEvent = LessonEvent(
      id: id,
      day: lesson.lessionDate.day.toString(),
      instructorId: lesson.instructorId,
      lessonAt: lesson.lessionDate,
      pupilName: pupil.name,
      pupilId: pupil.id,
    );
    var snap = await lessonEvent.get();
    if (snap.exists) {
      await lessonEvent.update();
      return true;
    }
    await lessonEvent.add();
    this._logger.info('Lesson ${lesson.id} for pupil ${pupil.id} by instructor ${lesson.instructorId} creation complete including events.');
    return true;
  }
}
