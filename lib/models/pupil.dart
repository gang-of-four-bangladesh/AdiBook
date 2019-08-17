import 'package:adibook/core/type_conversion.dart';
import 'package:adibook/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  Pupil(
      {this.id,
      this.name,
      this.phoneNumber,
      this.licenseNo,
      this.address,
      this.dateOfBirth,
      this.eyeTest = false,
      this.theoryRecord = false,
      this.previousExperience = false})
      : this.createdAt = null,
        this.updatedAt = null;
  String id;
  String name;
  String address;
  String phoneNumber;
  String licenseNo;
  DateTime dateOfBirth;
  bool eyeTest;
  bool theoryRecord;
  bool previousExperience;
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
      PreviousExperiencehKey: previousExperience,
      CreatedAtKey: createdAt,
      UpdatedAtKey: updatedAt
    };
  }

  Future<void> _snapshotToPupil(DocumentSnapshot snapshot) async {
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
    await _snapshotToPupil(await this.get());
    return this;
  }

  Future<DocumentSnapshot> get() async {
    return Firestore.instance
        .collection(FirestorePath.PupilCollection)
        .document(this.id)
        .get();
  }

  Future add() async {
    try {
      this.createdAt = DateTime.now().toUtc();
      Firestore.instance
          .collection(FirestorePath.PupilCollection)
          .document(this.id)
          .setData(this.toJson());
      print('$this created successfully.');
      return true;
    } catch (e) {
      print('user creation failed. $e');
      return false;
    }
  }

  Future update() async {
    try {
      this.updatedAt = DateTime.now().toUtc();
      Firestore.instance
          .collection(FirestorePath.PupilCollection)
          .document(this.id)
          .updateData(this.toJson());
      print('$this created successfully.');
      return true;
    } catch (e) {
      print('user creation failed. $e');
      return false;
    }
  }

  Future delete() async {
    return Firestore.instance
        .collection(FirestorePath.PupilCollection)
        .document(this.id)
        .delete();
  }
}
