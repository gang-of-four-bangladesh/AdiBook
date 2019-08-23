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
      Logger('models->pp').shout('$ProgressPlanKey document does not exists.');
      return null;
    }
    await _toObject(progressPlanSnap);
    return this;
  }

  Future<DocumentSnapshot> get() async {
    var path = sprintf(FirestorePath.ProgressPlanDocumentPath,
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
      var path = sprintf(FirestorePath.ProgressPlanDocumentPath,
          [this.pupilId, this.instructorId]);
      this.updatedAt = DateTime.now().toUtc();
      this.progressPlanSubject.updatedAt = DateTime.now().toUtc();
      var jsonData = this._toJson();
      jsonData.addAll(
        {
          UpdatedAtKey: DateTime.now().toUtc(),
        },
      );
      await Firestore.instance
          .collection(path)
          .document(ProgressPlanKey)
          .updateData(jsonData);
      print('$this updated successfully.');
      return true;
    } catch (e) {
      print('progress plan update failed. $e');
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
      UpdatedAtKey: this.updatedAt.toUtc()
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
