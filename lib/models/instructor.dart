import 'package:flutter/foundation.dart';

class Instructor {
  static const String IdKey = 'iid';
  static const String NameKey = 'nam';
  static const String AddressKey = 'add';
  static const String PhoneNumberKey = 'phn';
  static const String LicenseKey = 'lno';
  static const String DateOfBirthKey = 'dob';
  static const String CreatedAtKey = 'createdAt';
  static const String UpdatedAtKey = 'updatedAt';

  Instructor(
      {@required String iid,
      @required String name,
      @required String phoneNumber,
      @required String licenseNo,
      String address,
      DateTime dateOfBirth,
      bool eyeTest = false,
      bool theoryRecord = false,
      bool previousExperience = false})
      : assert(iid != null),
        assert(name != null),
        assert(phoneNumber != null),
        assert(licenseNo != null),
        this.iid = iid,
        this.name = name,
        this.address = address,
        this.phoneNumber = phoneNumber,
        this.licenseNo = licenseNo,
        this.dateOfBirth = dateOfBirth,
        this.createdAt = DateTime.now().toUtc(),
        this.updateAt = null;
  String iid;
  String name;
  String address;
  String phoneNumber;
  String licenseNo;
  DateTime dateOfBirth;
  DateTime createdAt;
  DateTime updateAt;

  Map<String, dynamic> toJson() {
    return {
      IdKey: iid,
      NameKey: name,
      AddressKey: address,
      PhoneNumberKey: phoneNumber,
      LicenseKey: licenseNo,
      DateOfBirthKey: dateOfBirth,
      CreatedAtKey: createdAt,
      UpdatedAtKey: updateAt
    };
  }
}
