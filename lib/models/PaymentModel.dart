// To parse this JSON data, do
//
//     final payment = paymentFromJson(jsonString);

import 'dart:convert';

PaymentModel paymentFromJson(String str) =>
    PaymentModel.fromJson(json.decode(str));

String paymentToJson(PaymentModel data) => json.encode(data.toJson());

class PaymentModel {
  PaymentModel({
    this.message,
    this.data,
    this.code,
  });

  String message;
  Data data;
  int code;

  factory PaymentModel.fromJson(Map<String, dynamic> json) => PaymentModel(
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        code: json["code"] == null ? null : json["code"],
      );

  Map<String, dynamic> toJson() => {
        "message": message == null ? null : message,
        "data": data == null ? null : data.toJson(),
        "code": code == null ? null : code,
      };
}

class Data {
  Data({
    this.redirectUrl,
  });

  String redirectUrl;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        redirectUrl: json["redirect_url"] == null ? null : json["redirect_url"],
      );

  Map<String, dynamic> toJson() => {
        "redirect_url": redirectUrl == null ? null : redirectUrl,
      };
}
