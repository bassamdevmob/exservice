class AdStatus {
  final String name;

  AdStatus._(this.name);

  static final AdStatus active = AdStatus._("ACTIVE");
  static final AdStatus paused = AdStatus._("PAUSED");
  static final AdStatus expired = AdStatus._("EXPIRED");
}

class MediaType {
  final String name;

  MediaType._(this.name);

  static final MediaType image = MediaType._("IMAGE");
  static final MediaType video = MediaType._("VIDEO");
}
