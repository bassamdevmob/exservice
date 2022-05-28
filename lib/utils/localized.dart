import 'package:exservice/localization/app_localization.dart';

class Localized {
  String key;

  Localized(this.key);

  @override
  String toString() {
    return key.translate();
  }
}