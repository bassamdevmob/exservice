import 'package:exservice/models/entity/ad_model.dart';

class AdDetailsResponse {
  AdDetailsResponse({
    this.data,
    this.message,
    this.code,
  });

  AdModel data;
  String message;
  String code;

  factory AdDetailsResponse.fromJson(Map<String, dynamic> json) => AdDetailsResponse(
    data: json["data"] == null ? null : AdModel.fromJson(json["data"]),
    message: json["message"] == null ? null : json["message"],
    code: json["code"] == null ? null : json["code"],
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? null : data.toJson(),
    "message": message == null ? null : message,
    "code": code == null ? null : code,
  };
}