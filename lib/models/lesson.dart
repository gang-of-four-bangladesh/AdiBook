import 'dart:core';
import 'package:adibook/core/constants.dart';
import 'package:adibook/core/type_conversion.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:sprintf/sprintf.dart';
import 'package:uuid/uuid.dart';

class Lesson {
  static const String LessonDateKey = 'ldt';
  static const String LessonDurationKey = 'ldu';
  static const String PickUpLocationKey = 'pul';
  static const String DropOffLocationKey = 'dol';
  static const String VehicleTypeKey = 'vtp';
  static const String LessionTypeKey = 'ltp';
  static const String DiaryNotesKey = 'dnt';
  static const String ReportCardKey = 'rcd';
  static const String DocumentDownloadUrl = 'url';
  static const String HasAcknowledgedKey = 'ack';
  static const String CreatedAtKey = 'cat';
  static const String UpdatedAtKey = 'uat';
  Logger _logger;
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
      this.documentDownloadUrl,
      this.hasAcknowledged = false})
      : this.createdAt = null,
        this.updatedAt = null,
        this._logger = Logger('model->lession');

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
  String documentDownloadUrl;
  bool hasAcknowledged;
  DateTime createdAt;
  DateTime updatedAt;

  Map<String, dynamic> toJson() {
    return {
      LessonDateKey: lessionDate,
      LessonDurationKey: lessionDuration,
      PickUpLocationKey: pickupLocation.index,
      DropOffLocationKey: dropOffLocation.index,
      VehicleTypeKey: vehicleType.index,
      LessionTypeKey: lessionType.index,
      DiaryNotesKey: diaryNotes,
      ReportCardKey: reportCard,
      DocumentDownloadUrl: documentDownloadUrl,
      HasAcknowledgedKey: hasAcknowledged
    };
  }

  Future<void> _toObject(DocumentSnapshot snapshot) async {
    this.id = snapshot.documentID;
    this.lessionDate = snapshot[Lesson.LessionTypeKey];
    this.lessionDuration = snapshot[Lesson.LessonDurationKey];
    this.pickupLocation = snapshot[Lesson.PickUpLocationKey];
    this.dropOffLocation = snapshot[Lesson.DropOffLocationKey];
    this.vehicleType = VehicleType.values[snapshot[Lesson.VehicleTypeKey]];
    this.lessionType = LessionType.values[snapshot[Lesson.LessionTypeKey]];
    this.diaryNotes = snapshot[Lesson.DiaryNotesKey];
    this.reportCard = snapshot[Lesson.ReportCardKey];
    this.documentDownloadUrl = snapshot[Lesson.DocumentDownloadUrl];
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

  Future<bool> add() async {
    try {
      var path = sprintf(FirestorePath.LessonsOfAPupilColection,
          [this.pupilId, this.instructorId]);
      this.id = Uuid().v1();
      var json = this.toJson();
      this.createdAt = DateTime.now().toUtc();
      json[CreatedAtKey] = this.createdAt;
      Firestore.instance.collection(path).document(this.id).setData(json);
      this._logger.info('Lesson created successfully with data $json.');
      return true;
    } catch (e) {
      this._logger.shout('Lesson creation failed. Reason $e');
      return false;
    }
  }

  Future<bool> update() async {
    try {
      var path = sprintf(FirestorePath.LessonsOfAPupilColection,
          [this.pupilId, this.instructorId]);
      this.updatedAt = DateTime.now().toUtc();
      var json = this.toJson();
      json[UpdatedAtKey] = this.updatedAt;
      Firestore.instance.collection(path).document(this.id).updateData(json);
      this._logger.info('Lesson updated successfully with data $json.');
      return true;
    } catch (e) {
      this._logger.shout('Lesson update failed. Reason $e');
      return false;
    }
  }

  Future<void> delete() async {
    var path = sprintf(FirestorePath.LessonsOfAPupilColection,
        [this.pupilId, this.instructorId]);
    return Firestore.instance.collection(path).document(this.id).delete();
  }
}
