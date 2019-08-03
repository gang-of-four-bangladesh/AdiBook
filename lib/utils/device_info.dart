import 'dart:io';
import 'package:flutter/services.dart';
import 'package:device_info/device_info.dart';

class DeviceInfo {
  static final DeviceInfoPlugin _deviceInfoPlugin = new DeviceInfoPlugin();
  static Map<String, dynamic> _deviceData;
  static Future<void> initializeDeviceState() async{
    await _initPlatformState();
  }
  static bool get isOnPhysicalDevice {
    return _deviceData != null && _deviceData['isPhysicalDevice'];
  }

  static Future<Null> _initPlatformState() async {
    try {
      if (Platform.isAndroid) {
        _deviceData = await _readAndroidBuildData(await _deviceInfoPlugin.androidInfo);
      } else if (Platform.isIOS) {
        _deviceData = await _readIosDeviceInfo(await _deviceInfoPlugin.iosInfo);
      }
    } on PlatformException {
      _deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }
  }

  static Future<Map<String, dynamic>> _readAndroidBuildData(AndroidDeviceInfo build) async {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
    };
  }

  static Future<Map<String, dynamic>> _readIosDeviceInfo(IosDeviceInfo data) async{
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }
}
