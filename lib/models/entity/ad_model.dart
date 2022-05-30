import 'package:exservice/models/entity/location.dart';
import 'package:exservice/models/entity/user.dart';

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
  Extra extra;
  List<MediaEntity> media;

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
    extra: json["extra"] == null ? null : Extra.fromJson(json["extra"]),
    media: json["media"] == null ? null : List<MediaEntity>.from(json["media"].map((x) => MediaEntity.fromJson(x))),
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
    "extra": extra == null ? null : extra.toJson(),
    "media": media == null ? null : List<dynamic>.from(media.map((x) => x.toJson())),
  };
}

class Extra {
  Extra({
    this.type,
    this.trade,
    this.price,
    this.size,
    this.furniture,
    this.room,
    this.bath,
    this.garage,
    this.balcony,
    this.gym,
  });

  StandardValue type;
  StandardValue trade;
  NumericValue price;
  NumericValue size;
  StandardValue furniture;
  NumericValue room;
  NumericValue bath;
  NumericValue garage;
  NumericValue balcony;
  NumericValue gym;

  factory Extra.fromJson(Map<String, dynamic> json) => Extra(
    type: json["type"] == null ? null : StandardValue.fromJson(json["type"]),
    trade: json["trade"] == null ? null : StandardValue.fromJson(json["trade"]),
    price: json["price"] == null ? null : NumericValue.fromJson(json["price"]),
    size: json["size"] == null ? null : NumericValue.fromJson(json["size"]),
    furniture: json["furniture"] == null ? null : StandardValue.fromJson(json["furniture"]),
    room: json["room"] == null ? null : NumericValue.fromJson(json["room"]),
    bath: json["bath"] == null ? null : NumericValue.fromJson(json["bath"]),
    garage: json["garage"] == null ? null : NumericValue.fromJson(json["garage"]),
    balcony: json["balcony"] == null ? null : NumericValue.fromJson(json["balcony"]),
    gym: json["gym"] == null ? null : NumericValue.fromJson(json["gym"]),
  );

  Map<String, dynamic> toJson() => {
    "type": type == null ? null : type.toJson(),
    "trade": trade == null ? null : trade.toJson(),
    "price": price == null ? null : price.toJson(),
    "size": size == null ? null : size.toJson(),
    "furniture": furniture == null ? null : furniture.toJson(),
    "room": room == null ? null : room.toJson(),
    "bath": bath == null ? null : bath.toJson(),
    "garage": garage == null ? null : garage.toJson(),
    "balcony": balcony == null ? null : balcony.toJson(),
    "gym": gym == null ? null : gym.toJson(),
  };
}

class NumericValue {
  NumericValue({
    this.value,
    this.unit,
    this.description,
  });

  int value;
  String unit;
  String description;

  factory NumericValue.fromJson(Map<String, dynamic> json) => NumericValue(
    value: json["value"] == null ? null : json["value"],
    unit: json["unit"] == null ? null : json["unit"],
    description: json["description"] == null ? null : json["description"],
  );

  Map<String, dynamic> toJson() => {
    "value": value == null ? null : value,
    "unit": unit == null ? null : unit,
    "description": description == null ? null : description,
  };
}

class StandardValue {
  StandardValue({
    this.type,
    this.flag,
  });

  String type;
  String flag;

  factory StandardValue.fromJson(Map<String, dynamic> json) => StandardValue(
    type: json["type"] == null ? null : json["type"],
    flag: json["flag"] == null ? null : json["flag"],
  );

  Map<String, dynamic> toJson() => {
    "type": type == null ? null : type,
    "flag": flag == null ? null : flag,
  };
}

class MediaEntity {
  MediaEntity({
    this.id,
    this.link,
    this.type,
  });

  int id;
  String link;
  String type;

  factory MediaEntity.fromJson(Map<String, dynamic> json) => MediaEntity(
    id: json["id"] == null ? null : json["id"],
    link: json["link"] == null ? null : json["link"],
    type: json["type"] == null ? null : json["type"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "link": link == null ? null : link,
    "type": type == null ? null : type,
  };
}