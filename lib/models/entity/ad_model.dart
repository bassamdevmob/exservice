
import 'dart:typed_data';

import 'package:exservice/models/entity/location.dart';
import 'package:exservice/models/entity/user.dart';
import 'package:exservice/models/response/config_response.dart';

class AdModel {
  AdModel({
    this.id,
    this.title,
    this.description,
    this.location,
    this.createdAt,
    this.marked,
    this.owner,
    this.status,
    this.views,
    this.type,
    this.trade,
    this.price,
    this.size,
    this.extra,
    this.media,
  });

  int id;
  String title;
  String description;
  Location location;
  DateTime createdAt;
  bool marked;
  User owner;
  String status;
  int views;
  OptionData type;
  OptionData trade;
  NumericData price;
  NumericData size;
  List<String> extra;
  List<BaseMedia> media;

  factory AdModel.fromJson(Map<String, dynamic> json) => AdModel(
    id: json["id"] == null ? null : json["id"],
    title: json["title"] == null ? null : json["title"],
    description: json["description"] == null ? null : json["description"],
    location: json["location"] == null ? null : Location.fromJson(json["location"]),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    marked: json["marked"] == null ? null : json["marked"],
    owner: json["owner"] == null ? null : User.fromJson(json["owner"]),
    status: json["status"] == null ? null : json["status"],
    views: json["views"] == null ? null : json["views"],
    type: json["type"] == null ? null : OptionData.fromJson(json["type"]),
    trade: json["trade"] == null ? null : OptionData.fromJson(json["trade"]),
    price: json["price"] == null ? null : NumericData.fromJson(json["price"]),
    size: json["size"] == null ? null : NumericData.fromJson(json["size"]),
    extra: json["extra"] == null ? null : List<String>.from(json["extra"].map((x) => x)),
    media: json["media"] == null ? null : List<Media>.from(json["media"].map((x) => Media.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "title": title == null ? null : title,
    "description": description == null ? null : description,
    "location": location == null ? null : location.toJson(),
    "created_at": createdAt == null ? null : createdAt.toIso8601String(),
    "marked": marked == null ? null : marked,
    "owner": owner == null ? null : owner.toJson(),
    "status": status == null ? null : status,
    "views": views == null ? null : views,
    "type": type == null ? null : type.toJson(),
    "trade": trade == null ? null : trade.toJson(),
    "price": price == null ? null : price.toJson(),
    "size": size == null ? null : size.toJson(),
    "extra": extra == null ? null : List<dynamic>.from(extra.map((x) => x)),
    "media": media == null ? null : List<dynamic>.from(media.map((x) => x.toJson())),
  };
}

abstract class BaseMedia {
  Map<String, dynamic> toJson();
}

class ReviewMedia implements BaseMedia {
  ReviewMedia({
    this.id,
    this.data,
  });

  int id;
  Uint8List data;

  @override
  Map<String, dynamic> toJson() {
    throw UnimplementedError();
  }
}

class Media implements BaseMedia {
  Media({
    this.id,
    this.link,
  });

  int id;
  String link;

  factory Media.fromJson(Map<String, dynamic> json) => Media(
    id: json["id"] == null ? null : json["id"],
    link: json["link"] == null ? null : json["link"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "link": link == null ? null : link,
  };
}

class NumericData {
  NumericData({
    this.value,
    this.unit,
    this.note,
  });

  int value;
  Unit unit;
  String note;

  factory NumericData.fromJson(Map<String, dynamic> json) => NumericData(
    value: json["value"] == null ? null : json["value"],
    unit: json["unit"] == null ? null : Unit.fromJson(json["unit"]),
    note: json["note"] == null ? null : json["note"],
  );

  Map<String, dynamic> toJson() => {
    "value": value == null ? null : value,
    "unit": unit == null ? null : unit.toJson(),
    "note": note == null ? null : note,
  };
}

class OptionData {
  OptionData({
    this.value,
    this.text,
    this.note,
  });

  String value;
  String text;
  String note;

  factory OptionData.fromJson(Map<String, dynamic> json) => OptionData(
    value: json["value"] == null ? null : json["value"],
    text: json["text"] == null ? null : json["text"],
    note: json["note"] == null ? null : json["note"],
  );

  Map<String, dynamic> toJson() => {
    "value": value == null ? null : value,
    "text": text == null ? null : text,
    "note": note == null ? null : note,
  };
}
