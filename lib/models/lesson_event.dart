import 'package:adibook/core/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logging/logging.dart';
import 'package:sprintf/sprintf.dart';

class LessonEvent {
  static const String PupilNameKey = 'pnm';
  static const String LessonTimeKey = "ltm";
  static const String PupilReferenceKey = 'pref';

  Logger _logger;
  LessonEvent({
    this.id,
    this.instructorId,
    this.day,
    this.pupilName,
    this.lessonTime,
  }) : this._logger = Logger('model->lesson_event');
  String id;
  String day;
  String instructorId;
  String pupilName;
  String lessonTime;

  Map<String, dynamic> _toJson() {
    return {
      this.day: FieldValue.arrayUnion(
        [
          {
            PupilNameKey: this.pupilName,
            LessonTimeKey: this.lessonTime,
          }
        ],
      ),
    };
  }

  Future<DocumentSnapshot> get() async {
    var path = sprintf(FirestorePath.LessonEventsOfAInstructorCollection,
        [this.instructorId, this.id]);
    return Firestore.instance.collection(path).document(this.id).get();
  }

  Future<bool> add() async {
    try {
      var path = sprintf(FirestorePath.LessonEventsOfAInstructorCollection,
          [this.instructorId, this.id]);
      this._logger.info(path);
      var json = this._toJson();
      await Firestore.instance.collection(path).document(this.id).setData(json);
      this._logger.info('Lesson event created successfully with data $json.');
      return true;
    } catch (e) {
      this._logger.shout('Lesson event creation failed. Reason $e');
      return false;
    }
  }

  Future<bool> update() async {
    try {
      var path = sprintf(FirestorePath.LessonEventsOfAInstructorCollection,
          [this.instructorId, this.id]);
      this._logger.info(path);
      var json = this._toJson();
      await Firestore.instance
          .collection(path)
          .document(this.id)
          .updateData(json);
      this._logger.info('Lesson event updated successfully with data $json.');
      return true;
    } catch (e) {
      this._logger.severe('Lesson event update failed. Reason $e');
      return false;
    }
  }

  Future<void> delete() async {
    var path = sprintf(FirestorePath.LessonEventsOfAInstructorCollection,
        [this.instructorId, this.id]);
    var json = {
      this.day: FieldValue.arrayRemove(
        [
          {
            PupilNameKey: this.pupilName,
            LessonTimeKey: this.lessonTime,
          }
        ],
      ),
    };
    await Firestore.instance
        .collection(path)
        .document(this.id)
        .updateData(json);
  }
}
