
class ResetPasswordRequest {
  ResetPasswordRequest({
    this.code,
    this.session,
    this.password,
    this.confirmPassword,
  });

  String code;
  String session;
  String password;
  String confirmPassword;

  factory ResetPasswordRequest.fromJson(Map<String, dynamic> json) => ResetPasswordRequest(
    code: json["code"] == null ? null : json["code"],
    session: json["session"] == null ? null : json["session"],
    password: json["password"] == null ? null : json["password"],
    confirmPassword: json["confirm_password"] == null ? null : json["confirm_password"],
  );

  Map<String, dynamic> toJson() => {
    "code": code == null ? null : code,
    "session": session == null ? null : session,
    "password": password == null ? null : password,
    "confirm_password": confirmPassword == null ? null : confirmPassword,
  };
}
