// To parse this JSON data, do
//
//     final adPricesList = adPricesListFromJson(jsonString);

import 'dart:convert';

AdPricesList adPricesListFromJson(String str) =>
    AdPricesList.fromJson(json.decode(str));

String adPricesListToJson(AdPricesList data) => json.encode(data.toJson());

class AdPricesList {
  AdPricesList({
    this.message,
    this.data,
    this.code,
  });

  String message;
  List<AdPrice> data;
  int code;

  factory AdPricesList.fromJson(Map<String, dynamic> json) => AdPricesList(
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? null
            : List<AdPrice>.from(json["data"].map((x) => AdPrice.fromJson(x))),
        code: json["code"] == null ? null : json["code"],
      );

  Map<String, dynamic> toJson() => {
        "message": message == null ? null : message,
        "data": data == null
            ? null
            : List<dynamic>.from(data.map((x) => x.toJson())),
        "code": code == null ? null : code,
      };
}

class AdPrice {
  AdPrice({
    this.id,
    this.appId,
    this.name,
    this.value,
    this.currency,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  int appId;
  String name;
  int value;
  String currency;
  DateTime createdAt;
  DateTime updatedAt;

  factory AdPrice.fromJson(Map<String, dynamic> json) => AdPrice(
        id: json["id"] == null ? null : json["id"],
        appId: json["app_id"] == null ? null : json["app_id"],
        name: json["name"] == null ? null : json["name"],
        value: json["value"] == null ? null : json["value"],
        currency: json["currency"] == null ? null : json["currency"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "app_id": appId == null ? null : appId,
        "name": name == null ? null : name,
        "value": value == null ? null : value,
        "currency": currency == null ? null : currency,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
      };
}
