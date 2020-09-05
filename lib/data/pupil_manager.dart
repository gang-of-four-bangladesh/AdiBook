import 'package:adibook/core/constants.dart';
import 'package:adibook/models/instructor.dart';
import 'package:adibook/models/progress_plan.dart';
import 'package:adibook/models/pupil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:sprintf/sprintf.dart';

class PupilManager {
  static const String PupilReferenceTaggedAtKey = 'pRef';
  static const String InstructorReferenceTaggedAtKey = 'iRef';
  Future<void> tagPupil(Pupil pupil, Instructor instructor) async {
    var _logger = Logger(this.runtimeType.toString());
    var ref = FirebaseFirestore.instance
        .collection(FirestorePath.PupilCollection)
        .doc(pupil.id);
    var path =
        sprintf(FirestorePath.PupilsOfAnInstructorCollection, [instructor.id]);
    var data = {
      PupilReferenceTaggedAtKey: ref,
      Pupil.NameKey: pupil.name,
    };
    await FirebaseFirestore.instance.collection(path).doc(pupil.id).set(data);
    _logger.fine('pupil ${pupil.id} tagged to instructor ${instructor.id}.');
  }

  Future<void> tagInstructor(Pupil pupil, Instructor instructor) async {
    var _logger = Logger(this.runtimeType.toString());
    var ref = FirebaseFirestore.instance
        .collection(FirestorePath.InstructorCollection)
        .doc(instructor.id);
    var path = sprintf(FirestorePath.InstructorsOfAPupilColection, [pupil.id]);
    var data = {
      InstructorReferenceTaggedAtKey: ref,
      Instructor.NameKey: instructor.name,
    };
    await FirebaseFirestore.instance
        .collection(path)
        .doc(instructor.id)
        .set(data);
    await FirebaseFirestore.instance
        .collection(path)
        .doc(instructor.id)
        .collection(FirestorePath.ProgressPlanCollection)
        .doc(ProgressPlan.ProgressPlanKey)
        .set({ProgressPlan.CreatedAtKey: DateTime.now().toUtc()});
    _logger.fine('instructor ${instructor.id} tagged to pupil ${pupil.id}.');
  }

  Future<QuerySnapshot> getLessions({
    @required String instructorId,
    @required String pupilId,
  }) async {
    var path = sprintf(FirestorePath.LessonsOfAPupilColection, [
      pupilId,
      instructorId,
    ]);
    print('Lessons path $path');
    return FirebaseFirestore.instance.collection(path).get();
  }

  Future<QuerySnapshot> getPayments({
    @required String instructorId,
    @required String pupilId,
  }) async {
    var path = sprintf(FirestorePath.PaymentsOfAPupilColection, [
      pupilId,
      instructorId,
    ]);
    print('Payments path $path');
    return FirebaseFirestore.instance.collection(path).get();
  }

  Future<Instructor> getDefaultInstructor(String pupilId) async {
    var path = sprintf(FirestorePath.InstructorsOfAPupilColection, [pupilId]);
    var instructorsDoc =
        await FirebaseFirestore.instance.collection(path).get();
    var defaultInstructorSnap = instructorsDoc.docs.first;
    return Instructor(id: defaultInstructorSnap.id).getInstructor();
  }
}
