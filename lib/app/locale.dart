// usage: context.tr(I18nKeys.name)
// usage: context.tr(I18nKeys.greeting, {'name': 'Flutter Dev'})

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Define a Keys class
class I18nKeys {
  static const String greeting = 'greeting';
  static const String name = 'name';
}

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static String translate(BuildContext context, String key, [Map<String, String>? params]) {
    return AppLocalizations.of(context)?._translate(key, params) ?? key;
  }

  late Map<String, String> _localizedStrings;

  Future<bool> load() async {
    String jsonString = await rootBundle.loadString(
      'resources/lang/${locale.languageCode}.json',
    ); //use assets/lang
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });

    return true;
  }

  String _translate(String key, [Map<String, String>? params]) {
    String translation = _localizedStrings[key] ?? key;

    if (params != null) {
      params.forEach((paramKey, paramValue) {
        translation = translation.replaceAll('{$paramKey}', paramValue);
      });
    }
    return translation;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'vi'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

extension AppLocalizationsExt on BuildContext {
  String tr(String key, [Map<String, String>? params]) {
    return AppLocalizations.translate(this, key, params);
  }
}
