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
  static const String posts = 'posts';
  static const String search = 'search';
  static const String users = 'users';
  static const String settings = 'settings';
  static const String login = 'login';
  static const String register = 'register';
  static const String logout = 'logout';
  static const String postDetail = 'post_detail';
  static const String userDetail = 'user_detail';
  static const String noPostsFound = 'no_posts_found';
  static const String addComment = 'add_comment';
  static const String sendComment = 'send_comment';
  static const String theme = 'theme';
  static const String language = 'language';
  static const String light = 'light';
  static const String dark = 'dark';
  static const String custom = 'custom';
  static const String english = 'english';
  static const String vietnamese = 'vietnamese';
  static const String userProfile = 'user_profile';
  static const String editComment = 'edit_comment';
  static const String updateComment = 'update_comment';
  static const String cancel = 'cancel';
  static const String update = 'update';
  static const String deleteComment = 'delete_comment';
  static const String delete = 'delete';
  static const String areYouSureDeleteComment = "are_you_sure_delete_comment";
  static const String select = "select";
  static const String bookmarkedPosts = "bookmarked_posts";
  static const String noBookmarkedPosts = "no_bookmarked_posts";
  static const String comments = "comments";
  static const String loginToComment = "login_to_comment";
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
    String jsonString = await rootBundle.loadString('assets/lang/${locale.languageCode}.json');
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
