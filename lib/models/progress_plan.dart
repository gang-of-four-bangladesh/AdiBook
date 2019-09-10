import 'package:adibook/core/constants.dart';
import 'package:adibook/core/type_conversion.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:sprintf/sprintf.dart';

class ProgressPlan {
  static const String ProgressPlanKey = "pp";
  static const String UpdatedAtKey = 'uat';
  static const String CreatedAtKey = 'cat';
  Logger _logger = Logger('model->progress_plan');

  ProgressPlan({
    @required this.pupilId,
    @required this.instructorId,
    this.progressPlanSubject,
  })  : this.createdAt = null,
        this.updatedAt = null;
  String instructorId;
  String pupilId;
  ProgressPlanSubject progressPlanSubject;
  DateTime createdAt;
  DateTime updatedAt;

  Future<void> _toObject(DocumentSnapshot snapshot) async {
    if (this.progressPlanSubject != null) {
      this.progressPlanSubject =
          await this.progressPlanSubject.toObject(snapshot);
    }
    this.updatedAt =
        TypeConversion.timeStampToDateTime(snapshot[ProgressPlan.UpdatedAtKey]);
  }

  Future<ProgressPlan> getProgressPlan() async {
    var progressPlanSnap = await this.get();
    if (!progressPlanSnap.exists) {
      this._logger.severe('$ProgressPlanKey document does not exists.');
      return null;
    }
    await _toObject(progressPlanSnap);
    return this;
  }

  Future<DocumentSnapshot> get() async {
    var path = sprintf(FirestorePath.ProgressPlanOfAPupilCollection,
        [this.pupilId, this.instructorId]);
    return Firestore.instance.collection(path).document(ProgressPlanKey).get();
  }

  Map<String, dynamic> _toJson() {
    return {
      this.progressPlanSubject.subjectName: this.progressPlanSubject == null
          ? null
          : this.progressPlanSubject.toJson()
    };
  }

  Future<bool> update() async {
    try {
      var path = sprintf(FirestorePath.ProgressPlanOfAPupilCollection,
          [this.pupilId, this.instructorId]);
      this.progressPlanSubject.updatedAt = DateTime.now();
      var json = this._toJson();
      this.updatedAt = DateTime.now().toUtc();
      json[UpdatedAtKey] = this.updatedAt;
      await Firestore.instance
          .collection(path)
          .document(ProgressPlanKey)
          .updateData(json);
      this._logger.info('$this updated successfully.');
      return true;
    } catch (e) {
      this._logger.shout('progress plan update failed. $e');
      return false;
    }
  }
}

class ProgressPlanSubject {
  static const String StatusKey = 'sts';
  static const String UpdatedAtKey = 'uat';
  ProgressPlanSubject({
    this.subjectName,
    this.subjectStatus,
  }) : updatedAt = null;

  Map<String, dynamic> toJson() {
    return {
      StatusKey: this.subjectStatus.index,
      UpdatedAtKey: this.updatedAt
    };
  }

  Future<ProgressPlanSubject> toObject(DocumentSnapshot snapshot) async {
    this.subjectStatus = ProgressSubjectStatus.values[snapshot[StatusKey]];
    this.updatedAt = TypeConversion.timeStampToDateTime(
            snapshot[ProgressPlanSubject.UpdatedAtKey]);
    return this;
  }

  String subjectName;
  ProgressSubjectStatus subjectStatus;
  DateTime updatedAt;
}
