import 'package:adibook/core/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:sprintf/sprintf.dart';

class LessonEvent {
  static const String PupilNameKey = 'pnm';
  static const String LessonTimeKey = "ltm";
  static const String PupilReferenceKey = 'pref';
  static const String PupilReferenceTaggedAtKey = 'pRef';

  Logger _logger;
  LessonEvent({
    @required this.id,
    @required this.instructorId,
    this.pupilId,
    this.day,
    this.pupilName,
    this.lessonAt,
  }) : this._logger = Logger('model->lesson_event');
  String id;
  String day;
  String instructorId;
  String pupilName;
  DateTime lessonAt;
  String pupilId;

  Map<String, dynamic> _toJson({bool isRemove = false}) {
    var ref = FirebaseFirestore.instance
        .collection(FirestorePath.PupilCollection)
        .doc(this.pupilId);
    var json = Map<String, dynamic>();
    if (isNotNullOrEmpty(pupilName)) json[PupilNameKey] = pupilName;
    if (isNotNullOrEmpty(lessonAt)) json[LessonTimeKey] = lessonAt.toUtc();
    if (isNotNullOrEmpty(ref)) json[PupilReferenceTaggedAtKey] = ref;
    if (isRemove)
      return {
        this.day: FieldValue.arrayRemove(
          [json],
        ),
      };

    return {
      this.day: FieldValue.arrayUnion(
        [json],
      ),
    };
  }

  Future<DocumentSnapshot> get() async {
    var path = sprintf(FirestorePath.LessonEventsOfAInstructorCollection,
        [this.instructorId, this.id]);
    return FirebaseFirestore.instance.collection(path).doc(this.id).get();
  }

  Future<LessonEvent> add() async {
    try {
      var path = sprintf(FirestorePath.LessonEventsOfAInstructorCollection,
          [this.instructorId, this.id]);
      await FirebaseFirestore.instance.collection(path).doc(this.id).set(this._toJson());
      this._logger.info('Lesson event created successfully.');
      return this;
    } catch (e) {
      this._logger.shout('Lesson event creation failed. Reason $e');
      return null;
    }
  }

  Future<LessonEvent> update() async {
    try {
      var path = sprintf(FirestorePath.LessonEventsOfAInstructorCollection,
          [this.instructorId, this.id]);
      await FirebaseFirestore.instance.collection(path).doc(this.id).update(this._toJson());
      this._logger.info('Lesson event updated successfully.');
      return this;
    } catch (e) {
      this._logger.severe('Lesson event update failed. Reason $e');
      return null;
    }
  }

  Future<void> delete() async {
    var path = sprintf(FirestorePath.LessonEventsOfAInstructorCollection,
        [this.instructorId, this.id]);
    // var json = {
    //   this.day: FieldValue.arrayRemove(
    //     [
    //       {
    //         PupilNameKey: this.pupilName,
    //         LessonTimeKey: this.lessonAt,
    //       }
    //     ],
    //   ),
    // };
    await FirebaseFirestore.instance
        .collection(path)
        .doc(this.id)
        .update(this._toJson(isRemove: true));
  }
}
