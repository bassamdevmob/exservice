class MediaModel {
  MediaModel({
    this.id,
    this.adId,
    this.link,
    this.type,
  });

  int id;
  int adId;
  String link;
  int type;

  factory MediaModel.fromJson(Map<String, dynamic> json) => MediaModel(
        id: json["id"] == null ? null : json["id"],
        adId: json["ad_id"] == null ? null : json["ad_id"],
        link: json["link"] == null ? null : json["link"],
        type: json["type"] == null ? null : json["type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "ad_id": adId == null ? null : adId,
        "link": link == null ? null : link,
        "type": type == null ? null : type,
      };
}
