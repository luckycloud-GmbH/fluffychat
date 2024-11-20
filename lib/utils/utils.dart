import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:matrix/matrix.dart';

import '../config/app_config.dart';
import '../config/setting_keys.dart';

mixin Utils {
  static Future<void> initConfig() async {
    try {
      var defaultHomeserver = await const FlutterSecureStorage()
          .read(key: SettingKeys.defaultHomeserver);
      defaultHomeserver ??= AppConfig.defaultHomeserver;
      final configJsonString = utf8.decode(
        (await http.get(
          Uri.parse('https://web-$defaultHomeserver/config.json'),
        ))
            .bodyBytes,
      );
      final configJson = json.decode(configJsonString);
      AppConfig.loadFromJson(configJson);
    } on FormatException catch (_) {
      Logs().i('[main] config.json invalid format');
    } catch (e) {
      Logs().i('[main] config.json not found', e);
    }
  }
}
