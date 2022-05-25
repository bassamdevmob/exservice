
class SwitchBusinessRequest {
  SwitchBusinessRequest({
    this.companyName,
    this.bio,
    this.website,
  });

  String companyName;
  String bio;
  String website;

  factory SwitchBusinessRequest.fromJson(Map<String, dynamic> json) => SwitchBusinessRequest(
    companyName: json["company_name"] == null ? null : json["company_name"],
    bio: json["bio"] == null ? null : json["bio"],
    website: json["website"] == null ? null : json["website"],
  );

  Map<String, dynamic> toJson() => {
    "company_name": companyName == null ? null : companyName,
    "bio": bio == null ? null : bio,
    "website": website == null ? null : website,
  };
}
