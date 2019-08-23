import 'dart:io';
import 'package:adibook/core/constants.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class StorageUpload {
  Future<String> uploadLessonFile(String filePath) async {
    var filename = basename(filePath);
    StorageReference _storageRef = FirebaseStorage.instance
        .ref()
        .child(StoragePath.LessonsFolder)
        .child(filename);
    var uploadStatus = _storageRef.putFile(
        File(filePath), StorageMetadata(contentType: 'application/pdf'));
    var taskSnap = await uploadStatus.onComplete;
    return taskSnap.ref.getDownloadURL();
  }
}
