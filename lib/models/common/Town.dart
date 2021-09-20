class Town {
  Town({
    this.id,
    this.name,
    this.image,
    this.latitude,
    this.longitude,
    this.country,
  });

  int id;
  String name;
  int latitude;
  int longitude;
  String country;
  String image;

  factory Town.fromJson(Map<String, dynamic> json) => Town(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        latitude: json["latitude"] == null ? null : json["latitude"],
        longitude: json["longitude"] == null ? null : json["longitude"],
        country: json["country"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "latitude": latitude == null ? null : latitude,
        "longitude": longitude == null ? null : longitude,
        "country": country == null ? null : country,
      };
}
