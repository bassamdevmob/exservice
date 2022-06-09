class PaymentResponse {
  PaymentResponse({
    this.data,
    this.message,
    this.code,
  });

  PaymentResult data;
  String message;
  String code;

  factory PaymentResponse.fromJson(Map<String, dynamic> json) => PaymentResponse(
    data: json["data"] == null ? null : PaymentResult.fromJson(json["data"]),
    message: json["message"] == null ? null : json["message"],
    code: json["code"] == null ? null : json["code"],
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? null : data.toJson(),
    "message": message == null ? null : message,
    "code": code == null ? null : code,
  };
}

class PaymentResult {
  PaymentResult({
    this.discount,
    this.period,
    this.cost,
    this.currency,
  });

  double discount;
  int period;
  double cost;
  String currency;

  factory PaymentResult.fromJson(Map<String, dynamic> json) => PaymentResult(
    discount: json["discount"] == null ? null : json["discount"].toDouble(),
    period: json["period"] == null ? null : json["period"],
    cost: json["cost"] == null ? null : json["cost"].toDouble(),
    currency: json["currency"] == null ? null : json["currency"],
  );

  Map<String, dynamic> toJson() => {
    "discount": discount == null ? null : discount,
    "period": period == null ? null : period,
    "cost": cost == null ? null : cost,
    "currency": currency == null ? null : currency,
  };
}
