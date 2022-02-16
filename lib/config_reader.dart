import 'dart:convert';
import 'dart:developer';
import 'package:flutter/services.dart';

abstract class ConfigReader {
  static late Map<String, dynamic> _config;
  static String tapAndroidTestKey = '';
  static String tapIOSTestKey = '';

  static Future<void> initialize() async {
    try {
      final configString =
          await rootBundle.loadString('assets/config/app_config.json');
      _config = json.decode(configString) as Map<String, dynamic>;
      tapAndroidTestKey = _config['tap_android_secretKey'];
      tapIOSTestKey = _config['tap_ios_secretKey'];
    } catch (e) {
      log(e.toString());
    }
  }
}
