
class RegisterRequest {
  RegisterRequest({
    this.username,
    this.account,
    this.password,
  });

  String username;
  String account;
  String password;

  factory RegisterRequest.fromJson(Map<String, dynamic> json) => RegisterRequest(
    username: json["username"] == null ? null : json["username"],
    account: json["account"] == null ? null : json["account"],
    password: json["password"] == null ? null : json["password"],
  );

  Map<String, dynamic> toJson() => {
    "username": username == null ? null : username,
    "account": account == null ? null : account,
    "password": password == null ? null : password,
  };
}
