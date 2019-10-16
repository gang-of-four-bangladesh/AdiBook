import 'package:adibook/core/constants.dart';
import 'package:adibook/core/type_conversion.dart';
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
    this.userType = UserType.Instructor,
    this.userToken,
    this.isVerified = false,
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
    return {
      NameKey: name,
      PhoneNumberKey: phoneNumber,
      UserTypeKey: userType.index,
      UserTokenKey: userToken,
      IsVerifiedKey: isVerified,
      ExpiryDateKey: expiryDate.toUtc()
    };
  }

  Future<void> _toObject(DocumentSnapshot snapshot) async {
    this.id = snapshot.documentID;
    this.name = snapshot[User.NameKey];
    this.phoneNumber = snapshot[User.PhoneNumberKey];
    this.userType = UserType.values[snapshot[User.UserTypeKey]];
    this.userToken = snapshot[User.UserTokenKey];
    this.isVerified = snapshot[User.IsVerifiedKey];
    this.expiryDate =
        TypeConversion.timeStampToDateTime(snapshot[User.ExpiryDateKey]);
    this.createdAt =
        TypeConversion.timeStampToDateTime(snapshot[User.CreatedAtKey]);
    this.updatedAt =
        TypeConversion.timeStampToDateTime(snapshot[User.UpdatedAtKey]);
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
    return Firestore.instance
        .collection(FirestorePath.UserCollection)
        .document(this.id)
        .get();
  }

  Future<bool> add() async {
    try {
      this.createdAt = DateTime.now();
      this.expiryDate = this.createdAt.add(Duration(days: 30));
      var json = this._toJson();
      json[CreatedAtKey] = this.createdAt.toUtc();
      await Firestore.instance
          .collection(FirestorePath.UserCollection)
          .document(this.id)
          .setData(json);
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
      await Firestore.instance
          .collection(FirestorePath.UserCollection)
          .document(this.id)
          .updateData(json);
      this._logger.info('User updated successfully with data $json.');
      return true;
    } catch (e) {
      this._logger.severe('User update failed. Reason $e');
      return false;
    }
  }

  Future<void> delete() async {
    await Firestore.instance
        .collection(FirestorePath.UserCollection)
        .document(this.id)
        .delete();
  }
}
