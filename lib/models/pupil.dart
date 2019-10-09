import 'package:adibook/core/constants.dart';
import 'package:adibook/core/type_conversion.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logging/logging.dart';

class Pupil {
  static const String NameKey = 'nam';
  static const String AddressKey = 'add';
  static const String PhoneNumberKey = 'phn';
  static const String LicenseKey = 'lno';
  static const String DateOfBirthKey = 'dob';
  static const String EyeTestKey = 'ets';
  static const String TheoryRecordKey = 'thr';
  static const String PreviousExperiencehKey = 'pex';
  static const String CreatedAtKey = 'cat';
  static const String UpdatedAtKey = 'uat';
  Logger _logger;
  Pupil(
      {this.id,
      this.name,
      this.phoneNumber,
      this.licenseNo,
      this.address,
      this.dateOfBirth,
      this.eyeTest,
      this.theoryRecord,
      this.previousExperience})
      : this.createdAt = null,
        this.updatedAt = null,
        this._logger = Logger('model->pupil');
  String id;
  String name;
  String address;
  String phoneNumber;
  String licenseNo;
  DateTime dateOfBirth;
  bool eyeTest;
  String theoryRecord;
  String previousExperience;
  DateTime createdAt;
  DateTime updatedAt;

  Map<String, dynamic> toJson() {
    return {
      NameKey: name,
      AddressKey: address,
      PhoneNumberKey: phoneNumber,
      LicenseKey: licenseNo,
      DateOfBirthKey: dateOfBirth,
      EyeTestKey: eyeTest,
      TheoryRecordKey: theoryRecord,
      PreviousExperiencehKey: previousExperience
    };
  }

  Future<void> _toObject(DocumentSnapshot snapshot) async {
    this.id = snapshot.documentID;
    this.name = snapshot[Pupil.NameKey];
    this.address = snapshot[Pupil.AddressKey];
    this.phoneNumber = snapshot[Pupil.PhoneNumberKey];
    this.licenseNo = snapshot[Pupil.LicenseKey];
    this.dateOfBirth =
        TypeConversion.timeStampToDateTime(snapshot[Pupil.DateOfBirthKey]);
    this.eyeTest = snapshot[Pupil.EyeTestKey];
    this.theoryRecord = snapshot[Pupil.TheoryRecordKey];
    this.previousExperience = snapshot[Pupil.PreviousExperiencehKey];
    this.createdAt =
        TypeConversion.timeStampToDateTime(snapshot[Pupil.CreatedAtKey]);
    this.updatedAt =
        TypeConversion.timeStampToDateTime(snapshot[Pupil.UpdatedAtKey]);
  }

  Future<Pupil> getPupil() async {
    var pupil = await this.get();
    if (!pupil.exists) {
      this._logger.severe('${this.id} pupil does not exists.');
      return null;
    }
    await _toObject(pupil);
    return this;
  }

  Future<DocumentSnapshot> get() async {
    return Firestore.instance
        .collection(FirestorePath.PupilCollection)
        .document(this.id)
        .get();
  }

  Future<bool> add() async {
    try {
      var json = this.toJson();
      this.createdAt = DateTime.now().toUtc();
      json[CreatedAtKey] = this.createdAt;
      Firestore.instance
          .collection(FirestorePath.PupilCollection)
          .document(this.id)
          .setData(json);
      this._logger.info('Pupil created successfully with data $json .');
      return true;
    } catch (e) {
      this._logger.shout('Pupil creation failed. Reason $e');
      return false;
    }
  }

  Future<bool> update() async {
    try {
      var json = this.toJson();
      this.updatedAt = DateTime.now().toUtc();
      json[UpdatedAtKey] = this.updatedAt;
      Firestore.instance
          .collection(FirestorePath.PupilCollection)
          .document(this.id)
          .updateData(json);
      this._logger.info('Pupil updated successfully with data $json.');
      return true;
    } catch (e) {
      this._logger.shout('Pupil update failed. Reason $e');
      return false;
    }
  }

  Future<void> delete() async {
    return Firestore.instance
        .collection(FirestorePath.PupilCollection)
        .document(this.id)
        .delete();
  }
}
