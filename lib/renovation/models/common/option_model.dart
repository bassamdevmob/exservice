class OptionModel {
  OptionModel({
    this.id,
    this.title,
    this.image,
  });

  int id;
  String title;
  String image;

  factory OptionModel.fromJson(Map<String, dynamic> json) => OptionModel(
    id: json["id"] == null ? null : json["id"],
    title: json["title"] == null ? null : json["title"],
    image: json["image"] == null ? null : json["image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "title": title == null ? null : title,
    "image": image == null ? null : image,
  };
}
