import 'package:adibook/core/constants.dart';
import 'package:adibook/models/instructor.dart';
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
    var ref = Firestore.instance
        .collection(FirestorePath.PupilCollection)
        .document(pupil.id);
    var path =
        sprintf(FirestorePath.PupilsOfAnInstructorCollection, [instructor.id]);
    var data = {
      PupilReferenceTaggedAtKey: ref,
      Pupil.NameKey: pupil.name,
    };
    await Firestore.instance.collection(path).document(pupil.id).setData(data);
    _logger.fine('pupil ${pupil.id} tagged to instructor ${instructor.id}.');
  }

  Future<void> tagInstructor(Pupil pupil, Instructor instructor) async {
    var _logger = Logger(this.runtimeType.toString());
    var ref = Firestore.instance
        .collection(FirestorePath.InstructorCollection)
        .document(instructor.id);
    var path = sprintf(FirestorePath.InstructorsOfAPupilColection, [pupil.id]);
    var data = {
      InstructorReferenceTaggedAtKey: ref,
      Instructor.NameKey: instructor.name,
    };
    await Firestore.instance
        .collection(path)
        .document(instructor.id)
        .setData(data);
    _logger.fine('instructor ${instructor.id} tagged to pupil ${pupil.id}.');
  }

  Future<QuerySnapshot> getLessions(
      {@required String instructorId, @required String pupilId}) async {
    var path = sprintf(
        FirestorePath.LessonsOfAPupilColection, [pupilId, instructorId]);
    return Firestore.instance.collection(path).getDocuments();
  }
}
