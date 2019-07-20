import 'package:flutter/foundation.dart';

class Pupil {
  static const String IdKey = 'pid';
  static const String NameKey = 'nam';
  static const String AddressKey = 'add';
  static const String PhoneNumberKey = 'phn';
  static const String LicenseKey = 'lno';
  static const String DateOfBirthKey = 'dob';
  static const String EyeTestKey = 'et';
  static const String TheoryRecordKey = 'tr';
  static const String PreviousExperiencehKey = 'pe';
  static const String CreatedAtKey = 'createdAt';
  static const String UpdatedAtKey = 'updatedAt';

  Pupil(
      {@required pid,
      @required name,
      @required phoneNumber,
      @required licenseNo,
      address,
      dateOfBirth,
      eyeTest = false,
      theoryRecord = false,
      previousExperience = false})
      : assert(pid != null),
        assert(name != null),
        assert(phoneNumber != null),
        assert(licenseNo != null),
        this.pid = pid,
        this.name = name,
        this.address = address,
        this.phoneNumber = phoneNumber,
        this.licenseNo = licenseNo,
        this.dateOfBirth = dateOfBirth,
        this.eyeTest = eyeTest,
        this.theoryRecord = theoryRecord,
        this.previousExperience = previousExperience,
        this.createdAt = DateTime.now().toUtc(),
        this.updateAt = null;
  String pid;
  String name;
  String address;
  String phoneNumber;
  String licenseNo;
  DateTime dateOfBirth;
  bool eyeTest;
  bool theoryRecord;
  bool previousExperience;
  DateTime createdAt;
  DateTime updateAt;

  Map<String, dynamic> toJson() {
    return {
      IdKey: pid,
      NameKey: name,
      AddressKey: address,
      PhoneNumberKey: phoneNumber,
      LicenseKey: licenseNo,
      DateOfBirthKey: dateOfBirth,
      EyeTestKey: eyeTest,
      TheoryRecordKey: theoryRecord,
      PreviousExperiencehKey: previousExperience,
      CreatedAtKey: createdAt,
      UpdatedAtKey: updateAt
    };
  }
}
