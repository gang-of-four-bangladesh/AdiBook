import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'constants.dart';
import '../models/instructor.dart';

class InstructorManager {
  CollectionReference get instructorCollection =>
      Firestore.instance.collection(FirestorePath.Instructor);

  Future<bool> add(Instructor instructor) async {
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    final DocumentReference document = instructorCollection.document(currentUser.uid);
    try {
      await document.setData(instructor.toJson());
      print('$instructor created successfully.');
      return true;
    } catch (e) {
      print('user creation failed. $e');
      return false;
    }
  }
}
