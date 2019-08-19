import 'package:adibook/core/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sprintf/sprintf.dart';

class ProgressPlan {
  static const String StatusKey = 'sts';
  static const String CreatedAtKey = 'cat';
  static const String UpdatedAtKey = 'uat';

  ProgressPlan({
    this.id,
    this.pupilId,
    this.instructorId,
    this.status = PupilProgresStep.None,
  })  : this.createdAt = null,
        this.updatedAt = null;
  String id;
  String instructorId;
  String pupilId;
  PupilProgresStep status;
  DateTime createdAt;
  DateTime updatedAt;

  Future<DocumentSnapshot> get() async {
    var path = sprintf(FirestorePath.ProgressPlanOfAPupilColection,
        [this.pupilId, this.instructorId]);
    return Firestore.instance.collection(path).document(this.id).get();
  }

  Map<String, dynamic> _toJson() {
    return {
      StatusKey: this.status,
    };
  }

  Future add() async {
    try {
      var path = sprintf(FirestorePath.ProgressPlanOfAPupilColection,
          [this.pupilId, this.instructorId]);
      this.createdAt = DateTime.now().toUtc();
      Firestore.instance
          .collection(path)
          .document(this.id)
          .setData(this._toJson());
      print('$this created successfully.');
      return true;
    } catch (e) {
      print('progress plan creation failed. $e');
      return false;
    }
  }

  Future<bool> update() async {
    try {
      var path = sprintf(FirestorePath.ProgressPlanOfAPupilColection,
          [this.pupilId, this.instructorId]);
      this.updatedAt = DateTime.now().toUtc();
      await Firestore.instance
          .collection(path)
          .document(this.id)
          .updateData(this._toJson());
      print('$this updated successfully.');
      return true;
    } catch (e) {
      print('progress plan update failed. $e');
      return false;
    }
  }

  Future<bool> delete() async {
    try {
      await Firestore.instance
          .collection(FirestorePath.UserCollection)
          .document(this.id)
          .delete();
      print('$this deleted successfully.');
      return true;
    } catch (e) {
      print('user deletion failed. $e');
      return false;
    }
  }
}
