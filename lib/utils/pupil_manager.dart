import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'constants.dart';
import '../models/pupil.dart';

class PupilManager {
  CollectionReference get instructorCollection =>
      Firestore.instance.collection(DatabaseDocumentPath.InstructorCollection);

  Future add(Pupil pupil) async {
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    String pupilCollectionPath = "${currentUser.uid}/${DatabaseDocumentPath.PupilsCollection}";
    final DocumentReference document = instructorCollection.document(pupilCollectionPath);
    try {
      document.setData(pupil.toJson());
      print('$pupil created successfully.');
      return true;
    } catch (e) {
      print('user creation failed. $e');
      return false;
    }
  }
}
