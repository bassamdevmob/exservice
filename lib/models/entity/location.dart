
class Location {
  Location({
    this.country,
    this.city,
    this.longitude,
    this.latitude,
  });

  String country;
  String city;
  String longitude;
  String latitude;

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    country: json["country"] == null ? null : json["country"],
    city: json["city"] == null ? null : json["city"],
    longitude: json["longitude"] == null ? null : json["longitude"],
    latitude: json["latitude"] == null ? null : json["latitude"],
  );

  Map<String, dynamic> toJson() => {
    "country": country == null ? null : country,
    "city": city == null ? null : city,
    "longitude": longitude == null ? null : longitude,
    "latitude": latitude == null ? null : latitude,
  };
}