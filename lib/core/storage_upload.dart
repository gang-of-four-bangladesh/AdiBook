import 'dart:io';
import 'package:adibook/core/constants.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart';

class StorageUpload {
  Logger _logger = Logger('stograge_upload');
  Future<String> uploadLessonFile(String filePath) async {
    this._logger.info('Uploading lessons file $filePath');
    if (filePath == null) return null;
    var filename = basename(filePath);
    StorageReference _storageRef = FirebaseStorage.instance
        .ref()
        .child(StoragePath.LessonsFolder)
        .child(filename);
    var uploadStatus = _storageRef.putFile(
        File(filePath), StorageMetadata(contentType: 'application/pdf'));
    var taskSnap = await uploadStatus.onComplete;
    var dowloadUrl = await taskSnap.ref.getDownloadURL();
    this._logger.info('Download url is $dowloadUrl;');
    return dowloadUrl.toString();
  }
}
