
class EditAdRequest {
  EditAdRequest({
    this.title,
    this.description,
  });

  String title;
  String description;

  factory EditAdRequest.fromJson(Map<String, dynamic> json) => EditAdRequest(
    title: json["title"] == null ? null : json["title"],
    description: json["description"] == null ? null : json["description"],
  );

  Map<String, dynamic> toJson() => {
    "title": title == null ? null : title,
    "description": description == null ? null : description,
  };
}
