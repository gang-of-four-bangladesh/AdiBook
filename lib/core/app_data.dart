class AppData {
  static final AppData _appData = new AppData._internal();

  Map<String, dynamic> contextualInfo;

  factory AppData() {
    return _appData;
  }

  AppData._internal();
}

final appData = AppData();
