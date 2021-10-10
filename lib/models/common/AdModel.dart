import 'package:exservice/models/options/GetOptionsModel.dart';

import 'Media.dart';
import 'Town.dart';
import 'User.dart';

class AdModel {
  AdModel({
    this.id,
    this.title,
    this.description,
    this.ownerId,
    this.townId,
    this.appId,
    this.thumbnail,
    this.longitude,
    this.latitude,
    this.status,
    this.pausedAt,
    this.validtyDate,
    this.isFree,
    this.detailedLocation,
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
  int ownerId;
  int townId;
  int appId;
  String thumbnail;
  double longitude;
  double latitude;
  int status;
  DateTime pausedAt;
  DateTime validtyDate;
  DateTime createdAt = DateTime.now();
  int isFree;
  String detailedLocation;
  bool saved;
  int totalViews;
  Town town;
  User owner;
  Attributes attr;
  List<Media> media;

  String get firstImage {
    for (Media m in media) if (m.type == 1) return m.link;
    return null;
  }

  List<Media> get images {
    return media.where((m) => m.type == 1).toList();
  }

  String get firstVideo {
    for (Media m in media) if (m.type == 2) return m.link;
    return null;
  }

  factory AdModel.fromJson(Map<String, dynamic> json) => AdModel(
        id: json["id"] == null ? null : json["id"],
        title: json["title"] == null ? null : json["title"],
        description: json["description"] == null ? null : json["description"],
        ownerId: json["owner_id"] == null ? null : json["owner_id"],
        townId: json["town_id"] == null ? null : json["town_id"],
        appId: json["app_id"] == null ? null : json["app_id"],
        thumbnail: json["thumbnail"] == null ? null : json["thumbnail"],
        longitude: json["longitude"] == null ? null : json["longitude"],
        latitude: json["latitiude"] == null ? null : json["latitiude"],
        status: json["status"] == null ? null : json["status"],
        pausedAt: json["paused_at"] == null
            ? null
            : DateTime.parse(json["paused_at"]),
        validtyDate: json["validty_date"] == null
            ? null
            : DateTime.parse(json["validty_date"]),
        isFree: json["is_free"] == null ? null : json["is_free"],
        detailedLocation: json["detailed_location"] == null
            ? null
            : json["detailed_location"],
        saved: json["saved_ads_count"] == null ? null : json["saved_ads_count"],
        town: json["town"] == null ? null : Town.fromJson(json["town"]),
        owner: json["owner"] == null ? null : User.fromJson(json["owner"]),
        attr: json["property_attributes"] == null
            ? null
            : Attributes.fromJson(json["property_attributes"]),
        media: json["media"] == null
            ? null
            : List<Media>.from(json["media"].map((x) => Media.fromJson(x))),
        totalViews: json["totalViews"] == null ? 0 : json["totalViews"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "title": title == null ? null : title,
        "description": description == null ? null : description,
        "owner_id": ownerId == null ? null : ownerId,
        "town_id": townId == null ? null : townId,
        "app_id": appId == null ? null : appId,
        "thumbnail": thumbnail == null ? null : thumbnail,
        "longitude": longitude == null ? null : longitude,
        "latitiude": latitude == null ? null : latitude,
        "status": status == null ? null : status,
        "paused_at": pausedAt == null ? null : pausedAt.toIso8601String(),
        "validty_date":
            validtyDate == null ? null : validtyDate.toIso8601String(),
        "is_free": isFree == null ? null : isFree,
        "detailed_location": detailedLocation == null ? null : detailedLocation,
        "saved_ads_count": saved == null ? null : saved,
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
  Option terrace;
  Option gym;
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
