import 'dart:core';
import 'package:adibook/core/type_conversion.dart';
import 'package:adibook/utils/constants.dart';
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
  static const String LessionTypeKey = 'ltp';
  static const String DiaryNotesKey = 'dnt';
  static const String ReportCardKey = 'rcd';
  static const String HasAcknowledgedKey = 'ack';
  static const String CreatedAtKey = 'cat';
  static const String UpdatedAtKey = 'uat';

  Lesson(
      {@required this.pupilId,
      @required this.instructorId,
      this.id,
      this.lessionDate,
      this.lessionDuration,
      this.pickupLocation,
      this.dropOffLocation,
      this.vehicleType,
      this.lessionType,
      this.diaryNotes,
      this.reportCard,
      this.hasAcknowledged = false})
      : this.createdAt = null,
        this.updatedAt = null;

  String id;
  String pupilId;
  String instructorId;
  DateTime lessionDate;
  int lessionDuration;
  TripLocation pickupLocation;
  TripLocation dropOffLocation;
  VehicleType vehicleType;
  LessionType lessionType;
  String diaryNotes;
  String reportCard;
  bool hasAcknowledged;
  DateTime createdAt;
  DateTime updatedAt;

  Map<String, dynamic> toJson() {
    return {
      LessonDateKey: lessionDate,
      LessonDurationKey: lessionDuration,
      PickUpLocationKey: pickupLocation,
      DropOffLocationKey: dropOffLocation,
      VehicleTypeKey: vehicleType,
      LessionTypeKey: lessionType,
      DiaryNotesKey: diaryNotes,
      ReportCardKey: reportCard,
      HasAcknowledgedKey: hasAcknowledged,
      CreatedAtKey: createdAt,
      UpdatedAtKey: updatedAt
    };
  }

  Future<void> _snapshotToLession(DocumentSnapshot snapshot) async {
    this.id = snapshot.documentID;
    this.lessionDate = snapshot[Lesson.LessionTypeKey];
    this.lessionDuration = snapshot[Lesson.LessonDurationKey];
    this.pickupLocation = snapshot[Lesson.PickUpLocationKey];
    this.dropOffLocation = snapshot[Lesson.DropOffLocationKey];
    this.vehicleType = VehicleType.values[snapshot[Lesson.VehicleTypeKey]];
    this.lessionType = LessionType.values[snapshot[Lesson.LessionTypeKey]];
    this.diaryNotes = snapshot[Lesson.DiaryNotesKey];
    this.reportCard = snapshot[Lesson.ReportCardKey];
    this.createdAt =
        TypeConversion.timeStampToDateTime(snapshot[Lesson.CreatedAtKey]);
    this.updatedAt =
        TypeConversion.timeStampToDateTime(snapshot[Lesson.UpdatedAtKey]);
  }

  Future<Lesson> getLession() async {
    var lession = await this.get();
    if (!lession.exists) {
      Logger('lession').shout(
          'Lession id ${this.id} for pupil ${this.pupilId} and instructor ${this.instructorId} does not exits!');
      return null;
    }
    await _snapshotToLession(lession);
    return this;
  }

  Future<DocumentSnapshot> get() async {
    var path = sprintf(FirestorePath.LessonsOfAPupilColection,
        [this.pupilId, this.instructorId]);
    return Firestore.instance.collection(path).document(this.id).get();
  }

  Future add() async {
    try {
      var path = sprintf(FirestorePath.LessonsOfAPupilColection,
          [this.pupilId, this.instructorId]);
      this.createdAt = DateTime.now().toUtc();
      Firestore.instance
          .collection(path)
          .document(this.id)
          .setData(this.toJson());
      print('$this created successfully.');
      return true;
    } catch (e) {
      print('lesson creation failed. $e');
      return false;
    }
  }

  Future update() async {
    try {
      var path = sprintf(FirestorePath.LessonsOfAPupilColection,
          [this.pupilId, this.instructorId]);
      this.updatedAt = DateTime.now().toUtc();
      Firestore.instance
          .collection(path)
          .document(this.id)
          .updateData(this.toJson());
      print('$this created successfully.');
      return true;
    } catch (e) {
      print('lesson creation failed. $e');
      return false;
    }
  }

  Future delete() async {
    var path = sprintf(FirestorePath.LessonsOfAPupilColection,
        [this.pupilId, this.instructorId]);
    return Firestore.instance.collection(path).document(this.id).delete();
  }
}
