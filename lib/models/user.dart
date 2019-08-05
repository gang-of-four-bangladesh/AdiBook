import 'package:adibook/core/type_conversion.dart';
import 'package:adibook/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  static const String IdKey = 'id';
  static const String NameKey = 'nam';
  static const String PhoneNumberKey = 'phn';
  static const String UserTypeKey = 'utp';
  static const String IsVerifiedKey = 'isv';
  static const String CreatedAtKey = 'cat';
  static const String UpdatedAtKey = 'uat';

  User(
      {String id,
      String name,
      String phoneNumber,
      UserType userType = UserType.Instructor,
      bool isVerified = false})
      : this.id = id,
        this.name = name,
        this.phoneNumber = phoneNumber,
        this.userType = userType,
        this.isVerified = isVerified,
        this.createdAt = DateTime.now().toUtc(),
        this.updatedAt = null;
  String id;
  String name;
  String phoneNumber;
  UserType userType;
  bool isVerified;
  DateTime createdAt;
  DateTime updatedAt;

  Map<String, dynamic> _toJson() {
    return {
      NameKey: name,
      PhoneNumberKey: phoneNumber,
      UserTypeKey: userType.index,
      IsVerifiedKey: isVerified,
      CreatedAtKey: createdAt,
      UpdatedAtKey: updatedAt
    };
  }

  Future<void> _snapshotToUser(DocumentSnapshot snapshot) async {
    this.id = snapshot.documentID;
    this.name = snapshot[User.NameKey];
    this.phoneNumber = snapshot[User.PhoneNumberKey];
    this.userType = snapshot[User.UserTypeKey];
    this.isVerified = snapshot[User.IsVerifiedKey];
    this.createdAt = TypeConversion.timeStampToDateTime(snapshot[User.CreatedAtKey]);
    this.updatedAt = TypeConversion.timeStampToDateTime(snapshot[User.UpdatedAtKey]);
  }

  Future<User> getUser() async {
    var userSanp = await this.get();
    if (!userSanp.exists) return null;
    await _snapshotToUser(userSanp);
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
      await Firestore.instance
          .collection(FirestorePath.UserCollection)
          .document(this.id)
          .setData(this._toJson());
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
          .collection(FirestorePath.UserCollection)
          .document(this.id)
          .updateData(this._toJson());
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
          .collection(FirestorePath.UserCollection)
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
