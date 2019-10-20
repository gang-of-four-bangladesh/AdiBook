import 'package:adibook/core/constants.dart';
import 'package:adibook/core/type_conversion.dart';
import 'package:adibook/models/pupil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logging/logging.dart';
import 'package:sprintf/sprintf.dart';

class Instructor {
  static const String NameKey = 'nam';
  static const String AddressKey = 'add';
  static const String PhoneNumberKey = 'phn';
  static const String LicenseKey = 'lno';
  static const String DateOfBirthKey = 'dob';
  static const String CreatedAtKey = 'cat';
  static const String UpdatedAtKey = 'uat';
  Logger _logger;

  Instructor(
      {this.id,
      this.name,
      this.licenseNo,
      this.address,
      this.phoneNumber,
      this.dateOfBirth})
      : this.createdAt = null,
        this.updatedAt = null,
        this._logger = Logger('mode->instructor');
  String id;
  String name;
  String address;
  String phoneNumber;
  String licenseNo;
  DateTime dateOfBirth;
  DateTime createdAt;
  DateTime updatedAt;

  Map<String, dynamic> toJson() {
    var json = Map<String, dynamic>();
    if (isNotNullOrEmpty(name)) json[NameKey] = name;
    if (isNotNullOrEmpty(address)) json[AddressKey] = address;
    if (isNotNullOrEmpty(phoneNumber)) json[PhoneNumberKey] = phoneNumber;
    if (isNotNullOrEmpty(licenseNo)) json[LicenseKey] = licenseNo;
    if (isNotNullOrEmpty(dateOfBirth)) json[DateOfBirthKey] = dateOfBirth;
    if (isNotNullOrEmpty(createdAt)) json[CreatedAtKey] = createdAt.toUtc();
    if (isNotNullOrEmpty(updatedAt)) json[UpdatedAtKey] = updatedAt.toUtc();
    return json;
  }

  Future<void> _toObject(DocumentSnapshot snapshot) async {
    this.id = snapshot.documentID;
    this.name = snapshot[Instructor.NameKey];
    this.address = snapshot[Instructor.AddressKey];
    this.phoneNumber = snapshot[Instructor.PhoneNumberKey];
    this.licenseNo = snapshot[Instructor.LicenseKey];
    this.dateOfBirth =
        TypeConversion.timeStampToDateTime(snapshot[Instructor.DateOfBirthKey]);
    this.createdAt =
        TypeConversion.timeStampToDateTime(snapshot[Instructor.CreatedAtKey]);
    this.updatedAt =
        TypeConversion.timeStampToDateTime(snapshot[Instructor.UpdatedAtKey]);
  }

  Future<Instructor> getInstructor() async {
    var snapshot = await this.get();
    if (!snapshot.exists) {
      this._logger.severe('Instructor id ${this.id} does not exits!');
      return null;
    }
    await _toObject(snapshot);
    return this;
  }

  Future<QuerySnapshot> getPupils() async {
    var path = sprintf(FirestorePath.PupilsOfAnInstructorCollection, [this.id]);
    return Firestore.instance
        .collection(path)
        .orderBy(Pupil.NameKey)
        .getDocuments();
  }

  Future<DocumentSnapshot> get() async {
    return Firestore.instance
        .collection(FirestorePath.InstructorCollection)
        .document(this.id)
        .get();
  }

  Future<Instructor> add() async {
    try {
      this.createdAt = DateTime.now();
      await Firestore.instance
          .collection(FirestorePath.InstructorCollection)
          .document(this.id)
          .setData(this.toJson());
      this._logger.info('Instructor created succussfully.');
      return this;
    } catch (e) {
      this._logger.shout('Instructor creation failed. Reason $e');
      return null;
    }
  }

  Future<Instructor> update() async {
    try {
      this.updatedAt = DateTime.now();
      await Firestore.instance
          .collection(FirestorePath.InstructorCollection)
          .document(this.id)
          .updateData(this.toJson());
      this._logger.info('Instructor updated successfully.');
      return this;
    } catch (e) {
      this._logger.shout('Instructor update failed. Reason $e');
      return null;
    }
  }

  Future<void> delete() async {
    await Firestore.instance
        .collection(FirestorePath.InstructorCollection)
        .document(this.id)
        .delete();
  }
}
