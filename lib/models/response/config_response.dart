class ConfigResponse {
  ConfigResponse({
    this.data,
    this.message,
    this.code,
  });

  Config data;
  String message;
  String code;

  factory ConfigResponse.fromJson(Map<String, dynamic> json) => ConfigResponse(
    data: json["data"] == null ? null : Config.fromJson(json["data"]),
    message: json["message"] == null ? null : json["message"],
    code: json["code"] == null ? null : json["code"],
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? null : data.toJson(),
    "message": message == null ? null : message,
    "code": code == null ? null : code,
  };
}

class Config {
  Config({
    this.type,
    this.trade,
    this.priceUnit,
    this.sizeUnit,
  });

  List<Option> type;
  List<Option> trade;
  List<Unit> priceUnit;
  List<Unit> sizeUnit;

  factory Config.fromJson(Map<String, dynamic> json) => Config(
    type: json["type"] == null ? null : List<Option>.from(json["type"].map((x) => Option.fromJson(x))),
    trade: json["trade"] == null ? null : List<Option>.from(json["trade"].map((x) => Option.fromJson(x))),
    priceUnit: json["price_unit"] == null ? null : List<Unit>.from(json["price_unit"].map((x) => Unit.fromJson(x))),
    sizeUnit: json["size_unit"] == null ? null : List<Unit>.from(json["size_unit"].map((x) => Unit.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "type": type == null ? null : List<dynamic>.from(type.map((x) => x.toJson())),
    "trade": trade == null ? null : List<dynamic>.from(trade.map((x) => x.toJson())),
    "price_unit": priceUnit == null ? null : List<dynamic>.from(priceUnit.map((x) => x.toJson())),
    "size_unit": sizeUnit == null ? null : List<dynamic>.from(sizeUnit.map((x) => x.toJson())),
  };
}

class Unit {
  Unit({
    this.value,
    this.ratio,
  });

  String value;
  double ratio;

  factory Unit.fromJson(Map<String, dynamic> json) => Unit(
    value: json["value"] == null ? null : json["value"],
    ratio: json["ratio"] == null ? null : json["ratio"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "value": value == null ? null : value,
    "ratio": ratio == null ? null : ratio,
  };
}
class Option {
  Option({
    this.value,
    this.text,
  });

  String value;
  String text;

  factory Option.fromJson(Map<String, dynamic> json) => Option(
    value: json["value"] == null ? null : json["value"],
    text: json["text"] == null ? null : json["text"],
  );

  Map<String, dynamic> toJson() => {
    "value": value == null ? null : value,
    "text": text == null ? null : text,
  };
}
