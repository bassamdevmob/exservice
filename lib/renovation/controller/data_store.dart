import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:exservice/models/common/Settings.dart';
import 'package:exservice/models/common/User.dart';

class DataStore {
  static final DataStore _instance = DataStore._internal();
  static const DEFAULT_TAG = "default";

  static DataStore get instance => _instance;

  DataStore._internal();

  Box _box;

  User _user;
  String _lang;
  String _fcmToken;
  Settings _settings;

  Future<void> init() async {
    Directory dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    _box = await Hive.openBox(DEFAULT_TAG);

    var storedUser = _box.get("user");
    _user = storedUser == null ? null : User.fromJson(jsonDecode(storedUser));
    var storedSettings = _box.get("settings");
    _settings = storedSettings == null
        ? Settings()
        : Settings.fromJson(jsonDecode(storedSettings));

    _lang = _box.get("lang", defaultValue: "en");
    _fcmToken = _box.get("fcm_token");
    log("Datastore initialized", name: "$runtimeType");
  }

  bool get hasUser => _user != null;

  User get user => _user;

  String get session => _user == null ? null : "Bearer ${_user.apiToken}";

  String get lang => _lang;

  String get fcmToken => _fcmToken;

  Settings get settings => _settings;

  set user(User value) =>
      _box.put("user", jsonEncode((_user = value).toJson()));

  set lang(String value) => _box.put("lang", _lang = value);

  set fcmToken(String value) => _box.put("fcm_token", _fcmToken = value);

  Future<void> setAccount(String account, String password) {
    _settings.account = account;
    _settings.password = password;
    return _box.put("settings", jsonEncode(_settings.toJson()));
  }

  Future<void> deleteUser() {
    _user = null;
    return _box.delete("user");
  }
}
