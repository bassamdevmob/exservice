class PaymentPackageResponse {
  PaymentPackageResponse({
    this.data,
    this.message,
    this.code,
  });

  Data data;
  String message;
  String code;

  factory PaymentPackageResponse.fromJson(Map<String, dynamic> json) => PaymentPackageResponse(
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
    this.cost,
    this.currency,
  });

  double cost;
  String currency;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    cost: json["cost"] == null ? null : json["cost"].toDouble(),
    currency: json["currency"] == null ? null : json["currency"],
  );

  Map<String, dynamic> toJson() => {
    "cost": cost == null ? null : cost,
    "currency": currency == null ? null : currency,
  };
}
