import 'package:exservice/models/entity/ad_model.dart';
import 'package:exservice/models/entity/meta.dart';

class AdsResponse {
  AdsResponse({
    this.data,
    this.message,
    this.code,
    this.meta,
  });

  List<AdModel> data;
  String message;
  String code;
  Meta meta;

  factory AdsResponse.fromJson(Map<String, dynamic> json) => AdsResponse(
    data: json["data"] == null ? null : List<AdModel>.from(json["data"].map((x) => AdModel.fromJson(x))),
    message: json["message"] == null ? null : json["message"],
    code: json["code"] == null ? null : json["code"],
    meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? null : List<dynamic>.from(data.map((x) => x.toJson())),
    "message": message == null ? null : message,
    "code": code == null ? null : code,
    "meta": meta == null ? null : meta.toJson(),
  };
}