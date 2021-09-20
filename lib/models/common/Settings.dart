// To parse this JSON data, do
//
//     final settings = settingsFromJson(jsonString);

import 'dart:convert';

Settings settingsFromJson(String str) => Settings.fromJson(json.decode(str));

String settingsToJson(Settings data) => json.encode(data.toJson());

class Settings {
  Settings({
    this.account,
    this.password,
    this.savePassword = false,
  });

  String account;
  String password;
  bool savePassword;

  factory Settings.fromJson(Map<String, dynamic> json) => Settings(
        account: json["account"] == null ? null : json["account"],
        password: json["password"] == null ? null : json["password"],
        savePassword:
            json["save_password"] == null ? null : json["save_password"],
      );

  Map<String, dynamic> toJson() => {
        "account": account == null ? null : account,
        "password": password == null ? null : password,
        "save_password": savePassword == null ? null : savePassword,
      };
}
