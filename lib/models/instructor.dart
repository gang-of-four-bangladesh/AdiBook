import 'package:adibook/core/type_conversion.dart';
import 'package:adibook/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sprintf/sprintf.dart';

class Instructor {
  static const String IdKey = 'id';
  static const String NameKey = 'nam';
  static const String AddressKey = 'add';
  static const String PhoneNumberKey = 'phn';
  static const String LicenseKey = 'lno';
  static const String DateOfBirthKey = 'dob';
  static const String CreatedAtKey = 'cat';
  static const String UpdatedAtKey = 'uat';

  Instructor(
      {String id,
      String name,
      String licenseNo,
      String address,
      String phoneNumber,
      DateTime dateOfBirth,
      bool eyeTest = false,
      bool theoryRecord = false,
      bool previousExperience = false})
      : this.id = id,
        this.name = name,
        this.address = address,
        this.phoneNumber = phoneNumber,
        this.licenseNo = licenseNo,
        this.dateOfBirth = dateOfBirth,
        this.createdAt = DateTime.now().toUtc(),
        this.updatedAt = null;
  String id;
  String name;
  String address;
  String phoneNumber;
  String licenseNo;
  DateTime dateOfBirth;
  DateTime createdAt;
  DateTime updatedAt;

  Map<String, dynamic> toJson() {
    return {
      NameKey: name,
      AddressKey: address,
      PhoneNumberKey: phoneNumber,
      LicenseKey: licenseNo,
      DateOfBirthKey: dateOfBirth,
      CreatedAtKey: createdAt,
      UpdatedAtKey: updatedAt
    };
  }

  Future<void> _snapshotToInstructor(DocumentSnapshot snapshot) async {
    print('org:${snapshot[Instructor.CreatedAtKey]} coverted:${snapshot[Instructor.CreatedAtKey].toDate()}, id: ${snapshot.documentID}');
    this.id = snapshot.documentID;
    this.name = snapshot[Instructor.NameKey];
    this.address = snapshot[Instructor.AddressKey];
    this.phoneNumber = snapshot[Instructor.PhoneNumberKey];
    this.licenseNo = snapshot[Instructor.LicenseKey];
    this.dateOfBirth = TypeConversion.timeStampToDateTime(snapshot[Instructor.DateOfBirthKey]);
    this.createdAt = TypeConversion.timeStampToDateTime(snapshot[Instructor.CreatedAtKey]);
    this.updatedAt = TypeConversion.timeStampToDateTime(snapshot[Instructor.UpdatedAtKey]);
  }

  Future<Instructor> getInstructor() async {
    await _snapshotToInstructor(await this.get());
    return this;
  }

  Future getPupils(String instructorId) async {
    var path = sprintf(FirestorePath.PupilsOfAnInstructorCollection, [instructorId]);
    return Firestore.instance.collection(path).getDocuments();
  }

  Future<DocumentSnapshot> get() async {
    return Firestore.instance
        .collection(FirestorePath.InstructorCollection)
        .document(this.id)
        .get();
  }

  Future<bool> add() async {
    try {
      await Firestore.instance
          .collection(FirestorePath.InstructorCollection)
          .document(this.id)
          .setData(this.toJson());
      print('$this created successfully.');
      return true;
    } catch (e) {
      print('user creation failed. $e');
      return false;
    }
  }

  Future<bool> update() async {
    try {
      this.updatedAt = DateTime.now().toUtc();
      await Firestore.instance
          .collection(FirestorePath.InstructorCollection)
          .document(this.id)
          .updateData(this.toJson());
      print('$this updated successfully.');
      return true;
    } catch (e) {
      print('user update failed. $e');
      return false;
    }
  }

  Future<bool> delete() async {
    try {
      await Firestore.instance
          .collection(FirestorePath.InstructorCollection)
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
