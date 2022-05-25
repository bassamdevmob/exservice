import 'package:exservice/models/entity/ad_model.dart';

class AdsResponse {
  AdsResponse({
    this.data,
    this.message,
    this.code,
  });

  List<AdModel> data;
  String message;
  String code;

  factory AdsResponse.fromJson(Map<String, dynamic> json) => AdsResponse(
    data: json["data"] == null ? null : List<AdModel>.from(json["data"].map((x) => AdModel.fromJson(x))),
    message: json["message"] == null ? null : json["message"],
    code: json["code"] == null ? null : json["code"],
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? null : List<dynamic>.from(data.map((x) => x.toJson())),
    "message": message == null ? null : message,
    "code": code == null ? null : code,
  };
}