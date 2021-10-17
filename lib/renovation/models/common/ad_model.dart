import 'package:exservice/models/options/GetOptionsModel.dart';

import 'media_model.dart';
import 'user_model.dart';
import 'town_model.dart';

class AdModel {
  AdModel({
    this.id,
    this.title,
    this.description,
    this.longitude,
    this.latitude,
    this.status,
    this.createdAt,
    this.date,
    this.isFree,
    this.saved,
    this.town,
    this.owner,
    this.attr,
    this.media,
    this.totalViews,
  });

  int id;
  String title;
  String description;
  double longitude;
  double latitude;
  int status;
  DateTime createdAt;
  DateTime date;
  int isFree;
  bool saved;
  int totalViews;
  TownModel town;
  UserModel owner;
  Attributes attr;
  List<MediaModel> media;

  String get firstImage {
    for (MediaModel m in media) if (m.type == 1) return m.link;
    return null;
  }

  List<MediaModel> get images {
    return media.where((m) => m.type == 1).toList();
  }

  String get firstVideo {
    for (MediaModel m in media) if (m.type == 2) return m.link;
    return null;
  }

  factory AdModel.fromJson(Map<String, dynamic> json) => AdModel(
        id: json["id"] == null ? null : json["id"],
        title: json["title"] == null ? null : json["title"],
        description: json["description"] == null ? null : json["description"],
        longitude: json["longitude"] == null ? null : json["longitude"],
        latitude: json["latitude"] == null ? null : json["latitude"],
        status: json["status"] == null ? null : json["status"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        isFree: json["is_free"] == null ? null : json["is_free"],
        saved: json["saved_ads_count"] == null ? null : json["saved_ads_count"],
        town: json["town"] == null ? null : TownModel.fromJson(json["town"]),
        owner: json["owner"] == null ? null : UserModel.fromJson(json["owner"]),
        attr: json["property_attributes"] == null
            ? null
            : Attributes.fromJson(json["property_attributes"]),
        media: json["media"] == null
            ? null
            : List<MediaModel>.from(json["media"].map((x) => MediaModel.fromJson(x))),
        totalViews: json["totalViews"] == null ? 0 : json["totalViews"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "title": title == null ? null : title,
        "description": description == null ? null : description,
        "longitude": longitude == null ? null : longitude,
        "latitude": latitude == null ? null : latitude,
        "status": status == null ? null : status,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "date": date == null ? null : date.toIso8601String(),
        "is_free": isFree == null ? null : isFree,
        "saved": saved == null ? null : saved,
        "town": town == null ? null : town.toJson(),
        "owner": owner == null ? null : owner.toJson(),
        "property_attributes": attr == null ? null : attr.toJson(),
        "media": media == null
            ? null
            : List<dynamic>.from(media.map((x) => x.toJson())),
        "totalViews": totalViews == null ? null : totalViews,
      };
}

class Attributes {
  Attributes({
    this.id,
    this.adId,
    this.price,
    this.size,
    this.terrace,
    this.gym,
    this.security,
    this.category,
    this.option,
    this.sizeUnit,
    this.priceOption,
    this.furniture,
    this.rooms,
    this.balcony,
    this.bath,
    this.garage,
  });

  int id;
  int adId;
  int price;
  int size;
  Option security;
  Option category;
  Option option;
  Option sizeUnit;
  Option priceOption;
  Option furniture;
  Option rooms;
  Option balcony;
  Option bath;
  Option garage;
  Option terrace;
  Option gym;

  factory Attributes.fromJson(Map<String, dynamic> json) => Attributes(
        id: json["id"] == null ? null : json["id"],
        adId: json["ad_id"] == null ? null : json["ad_id"],
        price: json["price"] == null ? null : json["price"],
        size: json["size"] == null ? null : json["size"],
        terrace: json["terrace"] == null ? null : json["terrace"],
        gym: json["gym"] == null ? null : json["gym"],
        security: json["security"],
        category: json["category"] == null
            ? null
            : Option.fromCategoryJson(json["category"]),
        option: json["option"] == null ? null : Option.fromJson(json["option"]),
        priceOption: json["price_option"] == null
            ? null
            : Option.fromJson(json["price_option"]),
        furniture: json["furniture"] == null
            ? null
            : Option.fromJson(json["furniture"]),
        sizeUnit: json["size_unit"] == null
            ? null
            : Option.fromNumericalJson(json["size_unit"]),
        rooms: json["rooms"] == null
            ? null
            : Option.fromNumericalJson(json["rooms"]),
        balcony: json["balcony"] == null
            ? null
            : Option.fromNumericalJson(json["balcony"]),
        bath: json["bath"] == null
            ? null
            : Option.fromNumericalJson(json["bath"]),
        garage: json["garage"] == null
            ? null
            : Option.fromNumericalJson(json["garage"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "ad_id": adId == null ? null : adId,
        "price": price == null ? null : price,
        "size": size == null ? null : size,
        "terrace": terrace == null ? null : terrace,
        "gym": gym == null ? null : gym,
        "security": security,
        "option": option == null ? null : option.toJson(),
        "size_unit": sizeUnit == null ? null : sizeUnit.toJson(),
        "price_option": priceOption == null ? null : priceOption.toJson(),
        "furniture": furniture == null ? null : furniture.toJson(),
        "rooms": rooms == null ? null : rooms.toJson(),
        "balcony": balcony == null ? null : balcony.toJson(),
        "bath": bath == null ? null : bath.toJson(),
        "garage": garage == null ? null : garage.toJson(),
        "category": category == null ? null : category.toJson(),
      };
}
