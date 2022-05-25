
class ChangePasswordRequest {
  ChangePasswordRequest({
    this.oldPassword,
    this.newPassword,
    this.confirmPassword,
  });

  String oldPassword;
  String newPassword;
  String confirmPassword;

  factory ChangePasswordRequest.fromJson(Map<String, dynamic> json) => ChangePasswordRequest(
    oldPassword: json["old_password"] == null ? null : json["old_password"],
    newPassword: json["new_password"] == null ? null : json["new_password"],
    confirmPassword: json["confirm_password"] == null ? null : json["confirm_password"],
  );

  Map<String, dynamic> toJson() => {
    "old_password": oldPassword == null ? null : oldPassword,
    "new_password": newPassword == null ? null : newPassword,
    "confirm_password": confirmPassword == null ? null : confirmPassword,
  };
}
