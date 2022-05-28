import 'dart:async';
import 'dart:convert';

import 'package:exservice/utils/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

extension LocalizedTranslation on String {
  String translate() {
    var context = navigatorKey.currentContext;
    return AppLocalization.of(context).translate(this);
  }
}

class AppLocalization {
  AppLocalization(this.locale);

  final Locale locale;

  static AppLocalization of(BuildContext context) {
    return Localizations.of<AppLocalization>(context, AppLocalization);
  }

  Map<String, String> _sentences;

  Future<bool> load() async {
    String data =
    await rootBundle.loadString('assets/lang/${locale.languageCode}.json');
    Map<String, dynamic> _result = json.decode(data);
    _sentences = _result.map((key, value) => MapEntry(key, value.toString()));
    return true;
  }

  String translate(String key) {
    return this._sentences[key] ?? '???';
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalization> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ar'].contains(locale.languageCode);

  @override
  Future<AppLocalization> load(Locale locale) async {
    AppLocalization localizations = new AppLocalization(locale);
    await localizations.load();

    print("Load ${locale.languageCode}");

    return localizations;
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => true;
}
