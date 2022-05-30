class AdStatus {
  final String name;

  AdStatus._(this.name);

  static final AdStatus active = AdStatus._("ACTIVE");
  static final AdStatus paused = AdStatus._("PAUSED");
  static final AdStatus expired = AdStatus._("EXPIRED");
}