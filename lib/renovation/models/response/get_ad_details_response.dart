
import 'package:exservice/renovation/models/common/ad_model.dart';

class GetAdDetailsResponse {
  GetAdDetailsResponse({
    this.message,
    this.data,
    this.code,
  });

  String message;
  AdModel data;
  int code;

  factory GetAdDetailsResponse.fromJson(Map<String, dynamic> json) =>
      GetAdDetailsResponse(
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null ? null : AdModel.fromJson(json["data"]),
        code: json["code"] == null ? null : json["code"],
      );

  Map<String, dynamic> toJson() => {
        "message": message == null ? null : message,
        "data": data == null ? null : data.toJson(),
        "code": code == null ? null : code,
      };
}
