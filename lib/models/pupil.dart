import 'package:adibook/core/constants.dart';
import 'package:adibook/core/formatter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logging/logging.dart';
import 'package:sprintf/sprintf.dart';

class Pupil {
  static const String NameKey = 'nam';
  static const String AddressKey = 'add';
  static const String PhoneNumberKey = 'phn';
  static const String LicenseKey = 'lno';
  static const String DateOfBirthKey = 'dob';
  static const String EyeTestKey = 'ets';
  static const String TheoryRecordKey = 'thr';
  static const String DocumentDownloadUrlKey = 'url';
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
      this.documentDownloadUrl,
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
  String documentDownloadUrl;
  String previousExperience;
  DateTime createdAt;
  DateTime updatedAt;

  Map<String, dynamic> toJson() {
    var json = Map<String, dynamic>();
    if (isNotNullOrEmpty(name)) json[NameKey] = name;
    if (isNotNullOrEmpty(phoneNumber)) json[PhoneNumberKey] = phoneNumber;
    if (isNotNullOrEmpty(address)) json[AddressKey] = address;
    if (isNotNullOrEmpty(licenseNo)) json[LicenseKey] = licenseNo;
    if (isNotNullOrEmpty(eyeTest)) json[EyeTestKey] = eyeTest;
    if (isNotNullOrEmpty(theoryRecord)) json[TheoryRecordKey] = theoryRecord;
    if (isNotNullOrEmpty(documentDownloadUrl))
      json[DocumentDownloadUrlKey] = documentDownloadUrl;
    if (isNotNullOrEmpty(previousExperience))
      json[PreviousExperiencehKey] = previousExperience;
    if (isNotNullOrEmpty(dateOfBirth))
      json[DateOfBirthKey] = dateOfBirth.toUtc();
    if (isNotNullOrEmpty(createdAt)) json[CreatedAtKey] = createdAt.toUtc();
    if (isNotNullOrEmpty(updatedAt)) json[UpdatedAtKey] = updatedAt.toUtc();
    return json;
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
    this.documentDownloadUrl = snapshot[Pupil.DocumentDownloadUrlKey];
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

  Future<Pupil> add() async {
    try {
      this.createdAt = DateTime.now();
      Firestore.instance
          .collection(FirestorePath.PupilCollection)
          .document(this.id)
          .setData(this.toJson());
      this._logger.info('Pupil created successfully.');
      return this;
    } catch (e) {
      this._logger.shout('Pupil creation failed. Reason $e');
      return null;
    }
  }

  Future<Pupil> update() async {
    try {
      this.updatedAt = DateTime.now();
      Firestore.instance
          .collection(FirestorePath.PupilCollection)
          .document(this.id)
          .updateData(this.toJson());
      this._logger.info('Pupil updated successfully.');
      return this;
    } catch (e) {
      this._logger.shout('Pupil update failed. Reason $e');
      return null;
    }
  }

  Future<void> delete() async {
    try {
      this.updatedAt = DateTime.now();
      Firestore.instance
          .collection(FirestorePath.PupilCollection)
          .document(this.id)
          .delete();
      this._logger.info('Pupil deleted successfully.');
      return this;
    } catch (e) {
      this._logger.shout('Pupil update failed. Reason $e');
      return null;
    }
  }

  Future<void> deleteOfAnInstructor(String pupilId, String instructorId) async {
    var path = sprintf(
        FirestorePath.PupilsOfAnInstructorCollection, [instructorId,pupilId]);
    return Firestore.instance.collection(path).document(this.id).delete();
  }
}
