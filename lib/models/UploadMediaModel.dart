class UploadData {
  UploadData({
    this.imagePath,
    this.videoPath,
  });

  String imagePath;
  String videoPath;

  factory UploadData.fromJson(Map<String, dynamic> json) => UploadData(
        imagePath: json["imagePath"] == null ? null : json["imagePath"],
        videoPath: json["videoPath"] == null ? null : json["videoPath"],
      );

  Map<String, dynamic> toJson() => {
        "imagePath": imagePath == null ? null : imagePath,
        "videoPath": videoPath == null ? null : videoPath,
      };
}
