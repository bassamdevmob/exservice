class Meta {
  Meta({
    this.path,
    this.perPage,
    this.nextPageUrl,
    this.prevPageUrl,
  });

  String path;
  String perPage;
  String nextPageUrl;
  String prevPageUrl;

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    path: json["path"],
    perPage: json["per_page"],
    nextPageUrl: json["next_page_url"],
    prevPageUrl: json["prev_page_url"],
  );

  Map<String, dynamic> toJson() => {
    "path": path,
    "per_page": perPage,
    "next_page_url": nextPageUrl,
    "prev_page_url": prevPageUrl,
  };
}
