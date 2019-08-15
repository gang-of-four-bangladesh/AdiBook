import 'dart:core';
import 'package:adibook/core/type_conversion.dart';
import 'package:adibook/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:sprintf/sprintf.dart';

class Lesson {
  static const String IdKey = 'id';
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
      {@required String pupilId,
      String id,
      DateTime lessionDate,
      int lessionDuration,
      String pickupLocation,
      String dropOffLocation,
      VehicleType vehicleType,
      LessionType lessionType,
      String diaryNotes,
      String reportCard,
      bool hasAcknowledged = false})
      : this.pupilId = pupilId,
        this.id = id,
        this.lessionDate = lessionDate,
        this.lessionDuration = lessionDuration,
        this.pickupLocation = pickupLocation,
        this.dropOffLocation = dropOffLocation,
        this.vehicleType = vehicleType,
        this.lessionType = lessionType,
        this.diaryNotes = diaryNotes,
        this.reportCard = reportCard,
        this.hasAcknowledged = hasAcknowledged,
        this.createdAt = null,
        this.updatedAt = null;

  String id;
  String pupilId;
  DateTime lessionDate;
  int lessionDuration;
  String pickupLocation;
  String dropOffLocation;
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
          'Lession id ${this.id} for pupil ${this.pupilId} does not exits!');
      return null;
    }
    await _snapshotToLession(lession);
    return this;
  }

  Future<DocumentSnapshot> get() async {
    var path = sprintf(FirestorePath.LessonsOfAPupilColection, [this.pupilId]);
    return Firestore.instance.collection(path).document(this.id).get();
  }

  Future add() async {
    try {
      var path =
          sprintf(FirestorePath.LessonsOfAPupilColection, [this.pupilId]);
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
      var path =
          sprintf(FirestorePath.LessonsOfAPupilColection, [this.pupilId]);
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
    var path = sprintf(FirestorePath.LessonsOfAPupilColection, [this.pupilId]);
    return Firestore.instance.collection(path).document(this.id).delete();
  }
}
