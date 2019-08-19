import 'dart:async';
import 'dart:io';
import 'package:adibook/core/constants.dart';
import 'package:adibook/data/user_manager.dart';
import 'package:logging/logging.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sprintf/sprintf.dart';

class LoggerSetup {
  static Future<void> setupLogger({LogWriter logWriter}) async {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((LogRecord rec) async {
      var message = '${rec.level.name}: ${rec.time}: ${rec.message}';
      logWriter.writeLog(message);
    }, onDone: () {
      print('Logger write done');
    });
  }
}

abstract class LogWriter {
  writeLog(String message);
}

class ConsoleLogWriter implements LogWriter {
  @override
  writeLog(String message) {
    print(message);
  }
}

class StorageLogWriter implements LogWriter {
  @override
  writeLog(String message) async {
    var currentUserId = await UserManager().currentUserId;
    if (currentUserId == null) currentUserId = 'anonymous';
    var currentDate = DateFormat('yyyyMMdd').format(DateTime.now().toUtc());
    var fileName = "${currentDate}_$currentUserId.txt";
    var storageFolderPath =
        sprintf(StoragePath.UserLogsFolder, [currentUserId]);
    var file = await _saveMessageToFile(fileName, message);
    if (await _doUpload())
      await _putFileToStorage(file, fileName, storageFolderPath);
  }

  Future<File> _saveMessageToFile(String fileName, String message) async {
    var appDocDirectory = await getApplicationDocumentsDirectory();
    var filePath = '${appDocDirectory.path}/$fileName';
    print(filePath);
    var logFile = File(filePath);
    if (!await logFile.exists()) {
      logFile = await logFile.create();
    }
    return await logFile.writeAsString(message, mode: FileMode.append);
  }

  Future<bool> _doUpload() async {
    var sharedPref = await SharedPreferences.getInstance();
    if (!sharedPref.containsKey(SharedPreferenceKeys.LogFileLastUploadedAtKey))
      return true;
    var lastUploadDateTime =
        sharedPref.getString(SharedPreferenceKeys.LogFileLastUploadedAtKey);
    print('Last Uploaded at: $lastUploadDateTime');
    var lastUploadedAt = DateTime.parse(lastUploadDateTime);
    var difference = DateTime.now().difference(lastUploadedAt).inSeconds;
    print(
        "lastUploadedAt:$lastUploadedAt, currentTime:${DateTime.now()}, Duration: $difference");
    if (difference >= 59) {
      print("It's time for upload log to firebase storage.");
      return true;
    }
    print("Wait some more seconds to upload log in firebase storage.");
    return false;
  }

  Future<void> _putFileToStorage(
      File file, String sourceFile, String folderPath) async {
    var sharedPref = await SharedPreferences.getInstance();
    final StorageReference storageRef =
        FirebaseStorage.instance.ref().child(folderPath).child(sourceFile);
    sharedPref.setString(SharedPreferenceKeys.LogFileLastUploadedAtKey,
        DateTime.now().toString());
    storageRef.putFile(file, StorageMetadata(contentType: 'text/plain'));
    await _deleteFileIfSizeExits(file);
  }

  Future<void> _deleteFileIfSizeExits(File file) async {
    var fileSize = await file.length() / (1024 * 1024); //MB
    print('Log file size in disk $fileSize MB.');
    if (fileSize >= 1) //Greater than or equal 1 MB
    {
      print('Deleting log file.');
      await file.delete();
    }
  }
}

// class LogManager implements Logger {
//   Type sourceType;
//   LogManager({Type sourceType}) : super();

//   @override
//   Level level;

//   @override
//   Map<String, Logger> get children => this.children;

//   @override
//   void clearListeners() {
//     this.clearListeners();
//   }

//   @override
//   void config(message, [Object error, StackTrace stackTrace]) {
//     this.config('SOURCE: ${this.sourceType.runtimeType.toString()}:$message', error, stackTrace);
//   }

//   @override
//   void fine(message, [Object error, StackTrace stackTrace]) {
//     this.fine('SOURCE: ${this.sourceType.runtimeType.toString()}:$message', error, stackTrace);
//   }

//   @override
//   void finer(message, [Object error, StackTrace stackTrace]) {
//     this.finer('SOURCE: ${this.sourceType.runtimeType.toString()}:$message', error, stackTrace);
//   }

//   @override
//   void finest(message, [Object error, StackTrace stackTrace]) {
//     this.finest('SOURCE: ${this.sourceType.runtimeType.toString()}:$message', error, stackTrace);
//   }

//   @override
//   String get fullName => this.fullName;

//   @override
//   void info(message, [Object error, StackTrace stackTrace]) {
//     this.info('SOURCE: ${this.sourceType.runtimeType.toString()}:$message', error, stackTrace);
//   }

//   @override
//   bool isLoggable(Level value) {
//     return this.isLoggable(value);
//   }

//   @override
//   void log(Level logLevel, message,
//       [Object error, StackTrace stackTrace, Zone zone]) {
//     this.log(logLevel, 'SOURCE: ${this.sourceType.runtimeType.toString()}:$message', error, stackTrace, zone);
//   }

//   @override
//   String get name => this.name;

//   @override
//   Stream<LogRecord> get onRecord => this.onRecord;

//   @override
//   Logger get parent => this.parent;

//   @override
//   void severe(message, [Object error, StackTrace stackTrace]) {
//     this.severe('SOURCE: ${this.sourceType.runtimeType.toString()}:$message', error, stackTrace);
//   }

//   @override
//   void shout(message, [Object error, StackTrace stackTrace]) {
//     this.shout('SOURCE: ${this.sourceType.runtimeType.toString()}:$message', error, stackTrace);
//   }

//   @override
//   void warning(message, [Object error, StackTrace stackTrace]) {
//     this.warning('SOURCE: ${this.sourceType.runtimeType.toString()}:$message', error, stackTrace);
//   }
// }
