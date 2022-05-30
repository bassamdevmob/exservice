class UserType {
  final String name;

  const UserType._(this.name);

  static const NORMAL = UserType._("NORMAL");
  static const BUSINESS = UserType._("BUSINESS");
}

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

enum ProfileTab {
  info,
  posts,
}