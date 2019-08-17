import 'package:adibook/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sprintf/sprintf.dart';

class ProgressPlan {
  static const String IntroducedKey = 'intr';
  static const String TalkThroughKey = 'tkth';
  static const String PromptedKey = 'prmt';
  static const String RarelyPromptedKey = 'rmprt';
  static const String IndependentKey = 'indp';

  ProgressPlan({
    this.id,
    this.pupilId,
    this.instructorId,
  })  : this.createdAt = null,
        this.updatedAt = null;
  String id;
  String instructorId;
  String pupilId;
  _ProgressLevel status;
  DateTime createdAt;
  DateTime updatedAt;

  Future<DocumentSnapshot> get() async {
    var path = sprintf(FirestorePath.ProgressPlanOfAPupilColection,
        [this.pupilId, this.instructorId]);
    return Firestore.instance.collection(path).document(this.id).get();
  }

  Map<String, dynamic> toJson() {
    return {
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
          .setData(this.toJson());
      print('$this created successfully.');
      return true;
    } catch (e) {
      print('user creation failed. $e');
      return false;
    }
  }
}

class _ProgressLevel {
  _ProgressDetails introduced;
  _ProgressDetails talkThrough;
  _ProgressDetails propmted;
  _ProgressDetails rarelyPrompted;
  _ProgressDetails independent;
}

class _ProgressDetails {
  String level;
  bool levelStatus;
  DateTime updatedAt;
}
