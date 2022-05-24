
import 'package:exservice/renovation/models/entity/ad_model.dart';

class FetchAdListResponse {
  FetchAdListResponse({
    this.message,
    this.data,
    this.code,
  });

  String message;
  List<AdModel> data;
  int code;

  factory FetchAdListResponse.fromJson(Map<String, dynamic> json) =>
      FetchAdListResponse(
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null ? null : List<AdModel>.from(json["data"].map((x) => AdModel.fromJson(x))),
        code: json["code"] == null ? null : json["code"],
      );

  Map<String, dynamic> toJson() => {
        "message": message == null ? null : message,
        "data": data == null ? null : List<dynamic>.from(data.map((x) => x.toJson())),
        "code": code == null ? null : code,
      };
}
