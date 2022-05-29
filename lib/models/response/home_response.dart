import 'package:exservice/models/entity/ad_model.dart';
import 'package:exservice/models/entity/category.dart';

class HomeResponse {
  HomeResponse({
    this.data,
    this.message,
    this.code,
  });

  Data data;
  String message;
  String code;

  factory HomeResponse.fromJson(Map<String, dynamic> json) => HomeResponse(
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
    this.ads,
    this.categories,
  });

  List<AdModel> ads;
  List<Category> categories;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    ads: json["ads"] == null ? null : List<AdModel>.from(json["ads"].map((x) => AdModel.fromJson(x))),
    categories: json["categories"] == null ? null :  List<Category>.from(json["categories"].map((x) => Category.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "ads": ads == null ? null : List<dynamic>.from(ads.map((x) => x.toJson())),
    "categories": categories == null ? null :  List<dynamic>.from(categories.map((x) => x.toJson())),
  };
}
