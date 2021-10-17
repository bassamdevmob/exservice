class SettingsModel {
  SettingsModel({
    this.account,
    this.password,
    this.savePassword = false,
  });

  String account;
  String password;
  bool savePassword;

  factory SettingsModel.fromJson(Map<String, dynamic> json) => SettingsModel(
        account: json["account"] == null ? null : json["account"],
        password: json["password"] == null ? null : json["password"],
        savePassword: json["save_password"] == null ? null : json["save_password"],
      );

  Map<String, dynamic> toJson() => {
        "account": account == null ? null : account,
        "password": password == null ? null : password,
        "save_password": savePassword == null ? null : savePassword,
      };
}
