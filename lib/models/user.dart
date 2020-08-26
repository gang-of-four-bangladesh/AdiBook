import 'package:adibook/core/constants.dart';
import 'package:adibook/core/formatter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logging/logging.dart';

class User {
  static const String NameKey = 'nam';
  static const String PhoneNumberKey = 'phn';
  static const String UserTypeKey = 'utp';
  static const String UserTokenKey = 'tkn';
  static const String IsVerifiedKey = 'isv';
  static const String ExpiryDateKey = 'end';
  static const String CreatedAtKey = 'cat';
  static const String UpdatedAtKey = 'uat';
  Logger _logger;
  User({
    this.id,
    this.name,
    this.phoneNumber,
    this.userType,
    this.userToken,
    this.isVerified,
  })  : this.createdAt = null,
        this.updatedAt = null,
        this._logger = Logger('model->user');
  String id;
  String name;
  String phoneNumber;
  UserType userType;
  String userToken;
  bool isVerified;
  DateTime expiryDate;
  DateTime createdAt;
  DateTime updatedAt;

  Map<String, dynamic> _toJson() {
    var json = Map<String, dynamic>();
    if (isNotNullOrEmpty(name)) json[NameKey] = name;
    if (isNotNullOrEmpty(phoneNumber)) json[PhoneNumberKey] = phoneNumber;
    if (isNotNullOrEmpty(userType)) json[UserTypeKey] = userType.index;
    if (isNotNullOrEmpty(userToken)) json[UserTokenKey] = userToken;
    if (isNotNullOrEmpty(isVerified)) json[IsVerifiedKey] = isVerified;
    if (isNotNullOrEmpty(expiryDate)) json[ExpiryDateKey] = expiryDate.toUtc();
    if (isNotNullOrEmpty(createdAt)) json[CreatedAtKey] = createdAt.toUtc();
    if (isNotNullOrEmpty(updatedAt)) json[UpdatedAtKey] = updatedAt.toUtc();
    return json;
  }

  Future<void> _toObject(DocumentSnapshot snapshot) async {
    this.id = snapshot.id;
    this.name = snapshot.data()[User.NameKey];
    this.phoneNumber = snapshot.data()[User.PhoneNumberKey];
    this.userType = UserType.values[snapshot.data()[User.UserTypeKey]];
    this.userToken = snapshot.data()[User.UserTokenKey];
    this.isVerified = snapshot.data()[User.IsVerifiedKey];
    this.expiryDate =
        TypeConversion.timeStampToDateTime(snapshot.data()[User.ExpiryDateKey]);
    this.createdAt =
        TypeConversion.timeStampToDateTime(snapshot.data()[User.CreatedAtKey]);
    this.updatedAt =
        TypeConversion.timeStampToDateTime(snapshot.data()[User.UpdatedAtKey]);
  }

  Future<User> getUser() async {
    var userSanp = await this.get();
    if (!userSanp.exists) {
      this._logger.severe('${this.id} user does not exists.');
      return null;
    }
    await _toObject(userSanp);
    return this;
  }

  Future<DocumentSnapshot> get() async {
    return FirebaseFirestore.instance
        .collection(FirestorePath.UserCollection)
        .doc(this.id)
        .get(GetOptions(source: Source.serverAndCache));
  }

  Future<bool> add() async {
    try {
      this.createdAt = DateTime.now();
      this.expiryDate = this.createdAt.add(Duration(days: 30));
      var json = this._toJson();
      await FirebaseFirestore.instance
          .collection(FirestorePath.UserCollection)
          .doc(this.id)
          .set(json);
      this._logger.info('User created successfully with data $json.');
      return true;
    } catch (e) {
      this._logger.shout('User creation failed. Reason $e');
      return false;
    }
  }

  Future<bool> update() async {
    try {
      this.updatedAt = DateTime.now();
      var json = this._toJson();
      json[UpdatedAtKey] = this.updatedAt.toUtc();
      await FirebaseFirestore.instance
          .collection(FirestorePath.UserCollection)
          .doc(this.id)
          .update(json);
      this._logger.info('User updated successfully with data $json.');
      return true;
    } catch (e) {
      this._logger.severe('User update failed. Reason $e');
      return false;
    }
  }

  Future<void> delete() async {
    await FirebaseFirestore.instance
        .collection(FirestorePath.UserCollection)
        .doc(this.id)
        .delete();
  }
}
