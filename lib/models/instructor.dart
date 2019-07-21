import 'package:adibook/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  Future<DocumentSnapshot> get() async {
    CollectionReference instructorCollection = Firestore.instance
        .collection(DatabaseDocumentPath.InstructorCollection);
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    return instructorCollection.document(currentUser.uid).get();
  }

  Future<bool> add() async {
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    try {
      await Firestore.instance
          .collection(DatabaseDocumentPath.InstructorCollection)
          .document(currentUser.uid)
          .setData(this.toJson());
      print('$this created successfully.');
      return true;
    } catch (e) {
      print('user creation failed. $e');
      return false;
    }
  }

  Future<bool> update() async {
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    try {
      this.updatedAt = DateTime.now().toUtc();
      await Firestore.instance
          .collection(DatabaseDocumentPath.InstructorCollection)
          .document(currentUser.uid)
          .updateData(this.toJson());
      print('$this updated successfully.');
      return true;
    } catch (e) {
      print('user update failed. $e');
      return false;
    }
  }

  Future<bool> delete() async {
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    try {
      await Firestore.instance
          .collection(DatabaseDocumentPath.InstructorCollection)
          .document(currentUser.uid)
          .delete();
      print('$this deleted successfully.');
      return true;
    } catch (e) {
      print('user deletion failed. $e');
      return false;
    }
  }
}
