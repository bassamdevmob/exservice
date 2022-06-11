import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:exservice/models/entity/user.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DataStore {
  Box<dynamic> box;

  static const THEME = "theme";
  static const LANG = "lang";
  static const TOKEN = "token";
  static const USER = "user";
  static const FCM_TOKEN = "fcm_token";
  static const DEFAULT_BOX = "kiosk_box";

  static final DataStore _instance = DataStore._internal();

  static DataStore get instance => _instance;

  DataStore._internal();

  /// Getters
  bool get isDarkModeEnabled => box.get(
        THEME,
        defaultValue: window.platformBrightness == Brightness.dark,
      );

  String get lang => box.get(LANG, defaultValue: "en");

  String get token =>
      box.containsKey(TOKEN) ? "Bearer ${box.get(TOKEN)}" : null;

  String get fcmToken => box.get(FCM_TOKEN);

  Future<void> init() async {
    await Hive.initFlutter();
    box = await Hive.openBox(DEFAULT_BOX);
    log("Datastore initialized", name: "$runtimeType");
  }

  /// Checkers
  bool get hasToken => box.containsKey(TOKEN);

  /// Setters
  Future<void> setLang(String value) => box.put(LANG, value);

  Future<void> setToken(String value) => box.put(TOKEN, value);

  Future<void> deleteCertificates() => box.deleteAll({TOKEN, USER, FCM_TOKEN});

  Future<void> switchTheme() => box.put(THEME, !isDarkModeEnabled);

  User get user {
    var subscriber = box.get(USER);
    if (subscriber == null) return null;
    return User.fromJson(json.decode(subscriber));
  }

  Future<void> setUser(User value) {
    return box.put(USER, json.encode(value.toJson()));
  }
}
