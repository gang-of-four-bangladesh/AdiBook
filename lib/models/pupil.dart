import 'package:adibook/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sprintf/sprintf.dart';

class Pupil {
  static const String IdKey = 'id';
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
      {id,
      name,
      phoneNumber,
      licenseNo,
      address,
      dateOfBirth,
      eyeTest = false,
      theoryRecord = false,
      previousExperience = false})
      : this.id = id,
        this.name = name,
        this.address = address,
        this.phoneNumber = phoneNumber,
        this.licenseNo = licenseNo,
        this.dateOfBirth = dateOfBirth,
        this.eyeTest = eyeTest,
        this.theoryRecord = theoryRecord,
        this.previousExperience = previousExperience,
        this.createdAt = DateTime.now().toUtc(),
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

  Future getall() async {
    var currentUser = await FirebaseAuth.instance.currentUser();
    var pupilCollectionPath =
        sprintf(DatabaseDocumentPath.PupilsCollection, [currentUser.uid]);
    return Firestore.instance
        .collection(pupilCollectionPath)
        .getDocuments();
  }

  Future get() async {
    var currentUser = await FirebaseAuth.instance.currentUser();
    var pupilCollectionPath =
        sprintf(DatabaseDocumentPath.PupilsCollection, [currentUser.uid]);
    return Firestore.instance
        .collection(pupilCollectionPath)
        .document(this.id)
        .get();
  }

  Future add() async {
    var currentUser = await FirebaseAuth.instance.currentUser();
    var pupilCollectionPath =
        sprintf(DatabaseDocumentPath.PupilsCollection, [currentUser.uid]);
    try {
      Firestore.instance
          .collection(pupilCollectionPath)
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
    var currentUser = await FirebaseAuth.instance.currentUser();
    var pupilCollectionPath =
        sprintf(DatabaseDocumentPath.PupilsCollection, [currentUser.uid]);
    try {
      this.updatedAt = DateTime.now().toUtc();
      Firestore.instance
          .collection(pupilCollectionPath)
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
    var currentUser = await FirebaseAuth.instance.currentUser();
    var pupilCollectionPath =
        sprintf(DatabaseDocumentPath.PupilsCollection, [currentUser.uid]);
    return Firestore.instance
        .collection(pupilCollectionPath)
        .document(this.id)
        .delete();
  }
}
