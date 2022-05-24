enum AccountRegistrationIdentifier { email, phone }

class AdStatus {
  final int id;

  AdStatus._(this.id);

  static final AdStatus active = AdStatus._(1);
  static final AdStatus paused = AdStatus._(2);
  static final AdStatus expired = AdStatus._(3);
}

enum AccountTab {
  details,
  advertisements,
}

enum DisplayFormat {
  list,
  grid,
}

class UserType {
  final String name;
  const UserType._(this.name);

  static const NORMAL = UserType._("NORMAL");
  static const BUSINESS = UserType._("BUSINESS");
}