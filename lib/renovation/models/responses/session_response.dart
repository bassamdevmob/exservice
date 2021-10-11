class SessionResponse {
  SessionResponse({
    this.data,
    this.message,
    this.code,
  });

  Data data;
  String message;
  int code;

  factory SessionResponse.fromJson(Map<String, dynamic> json) =>
      SessionResponse(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        message: json["message"] == null ? null : json["message"],
        code: json["code"] == null ? null : json["code"],
      );

  Map<String, dynamic> toJson() => {
        "data": data == null ? null : data.toJson(),
        "message": message == null ? null : message,
        "code": code == null ? null : code,
      };
}

class Data {
  Data({
    this.session,
  });

  String session;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        session: json["session_id"] == null ? null : json["session_id"],
      );

  Map<String, dynamic> toJson() => {
        "session_id": session == null ? null : session,
      };
}
