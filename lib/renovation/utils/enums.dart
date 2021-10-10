enum AccountRegistrationIdentifier { email, phone }

class AccountType {
  final int id;

  AccountType._(this.id);

  static final AccountType normal = AccountType._(1);
  static final AccountType company = AccountType._(2);
}

// enum AdStatus { active, paused, expired }

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