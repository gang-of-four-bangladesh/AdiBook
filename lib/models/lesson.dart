import 'dart:core';
import 'package:adibook/core/constants.dart';
import 'package:adibook/core/type_conversion.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:sprintf/sprintf.dart';

class Lesson {
  static const String LessonDateKey = 'ldt';
  static const String LessonDurationKey = 'ldu';
  static const String PickUpLocationKey = 'pul';
  static const String DropOffLocationKey = 'dol';
  static const String VehicleTypeKey = 'vtp';
  static const String LessonTypeKey = 'ltp';
  static const String DiaryNotesKey = 'dnt';
  static const String ReportCardKey = 'rcd';
  static const String DocumentDownloadUrlKey = 'url';
  static const String HasAcknowledgedKey = 'ack';
  static const String CreatedAtKey = 'cat';
  static const String UpdatedAtKey = 'uat';
  Logger _logger;
  Lesson(
      {@required this.pupilId,
      @required this.instructorId,
      this.id,
      this.lessonDate,
      this.lessonDuration,
      this.pickupLocation,
      this.dropOffLocation,
      this.vehicleType,
      this.lessonType,
      this.diaryNotes,
      this.reportCard,
      this.documentDownloadUrl,
      this.hasAcknowledged = false})
      : this.createdAt = null,
        this.updatedAt = null,
        this._logger = Logger('model->lession');

  String id;
  String pupilId;
  String instructorId;
  DateTime lessonDate;
  int lessonDuration;
  TripLocation pickupLocation;
  TripLocation dropOffLocation;
  VehicleType vehicleType;
  LessionType lessonType;
  String diaryNotes;
  String reportCard;
  String documentDownloadUrl;
  bool hasAcknowledged;
  DateTime createdAt;
  DateTime updatedAt;

  Map<String, dynamic> toJson() {
    var json = Map<String, dynamic>();
    if (isNotNullOrEmpty(lessonDate)) json[LessonDateKey] = lessonDate.toUtc();
    if (isNotNullOrEmpty(lessonDuration))
      json[LessonDurationKey] = lessonDuration;
    if (isNotNullOrEmpty(pickupLocation))
      json[PickUpLocationKey] = pickupLocation.index;
    if (isNotNullOrEmpty(dropOffLocation))
      json[DropOffLocationKey] = dropOffLocation.index;
    if (isNotNullOrEmpty(vehicleType)) json[VehicleTypeKey] = vehicleType.index;
    if (isNotNullOrEmpty(lessonType)) json[LessonTypeKey] = lessonType.index;
    if (isNotNullOrEmpty(diaryNotes)) json[DiaryNotesKey] = diaryNotes;
    if (isNotNullOrEmpty(reportCard)) json[ReportCardKey] = reportCard;
    if (isNotNullOrEmpty(documentDownloadUrl))
      json[DocumentDownloadUrlKey] = documentDownloadUrl;
    if (isNotNullOrEmpty(hasAcknowledged))
      json[HasAcknowledgedKey] = hasAcknowledged;
    if (isNotNullOrEmpty(createdAt)) json[CreatedAtKey] = createdAt.toUtc();
    if (isNotNullOrEmpty(updatedAt)) json[UpdatedAtKey] = updatedAt.toUtc();
    return json;
  }

  Future<void> _toObject(DocumentSnapshot snapshot) async {
    this.id = snapshot.documentID;
    this.lessonDate =
        TypeConversion.timeStampToDateTime(snapshot[Lesson.LessonDateKey]);
    this.lessonDuration = snapshot[Lesson.LessonDurationKey];
    this.pickupLocation =
        TripLocation.values[snapshot[Lesson.PickUpLocationKey]];
    this.dropOffLocation =
        TripLocation.values[snapshot[Lesson.DropOffLocationKey]];
    this.vehicleType = VehicleType.values[snapshot[Lesson.VehicleTypeKey]];
    this.lessonType = LessionType.values[snapshot[Lesson.LessonTypeKey]];
    this.diaryNotes = snapshot[Lesson.DiaryNotesKey];
    this.reportCard = snapshot[Lesson.ReportCardKey];
    this.documentDownloadUrl = snapshot[Lesson.DocumentDownloadUrlKey];
    this.hasAcknowledged = snapshot[Lesson.HasAcknowledgedKey];
    this.createdAt =
        TypeConversion.timeStampToDateTime(snapshot[Lesson.CreatedAtKey]);
    this.updatedAt =
        TypeConversion.timeStampToDateTime(snapshot[Lesson.UpdatedAtKey]);
  }

  Future<Lesson> getLession() async {
    var lession = await this.get();
    if (!lession.exists) {
      this._logger.severe(
          'Lession ${this.id} for pupil ${this.pupilId} and instructor ${this.instructorId} does not exits!');
      return null;
    }
    await _toObject(lession);
    return this;
  }

  Future<DocumentSnapshot> get() async {
    var path = sprintf(FirestorePath.LessonsOfAPupilColection,
        [this.pupilId, this.instructorId]);
    return Firestore.instance.collection(path).document(this.id).get();
  }

  Future<Lesson> add() async {
    try {
      var path = sprintf(FirestorePath.LessonsOfAPupilColection,
          [this.pupilId, this.instructorId]);
      this.createdAt = DateTime.now();
      this.id = TypeConversion.toNumberFormat(this.createdAt);
      Firestore.instance
          .collection(path)
          .document(this.id)
          .setData(this.toJson());
      this._logger.info('Lesson created successfully.');
      return this;
    } catch (e) {
      this._logger.shout('Lesson creation failed. Reason $e');
      return null;
    }
  }

  Future<Lesson> update() async {
    try {
      var path = sprintf(FirestorePath.LessonsOfAPupilColection,
          [this.pupilId, this.instructorId]);
      this.updatedAt = DateTime.now();
      Firestore.instance
          .collection(path)
          .document(this.id)
          .updateData(this.toJson());
      this._logger.info('Lesson updated successfully.');
      return this;
    } catch (e) {
      this._logger.shout('Lesson update failed. Reason $e');
      return null;
    }
  }

  Future<void> delete() async {
    var path = sprintf(FirestorePath.LessonsOfAPupilColection,
        [this.pupilId, this.instructorId]);
    return Firestore.instance.collection(path).document(this.id).delete();
  }
}
