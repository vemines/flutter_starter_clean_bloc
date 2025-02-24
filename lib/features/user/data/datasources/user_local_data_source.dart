import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';

abstract class UserLocalDataSource {
  Future<void> cacheUser(UserModel user);
  Future<UserModel?> getCachedUser();
  Future<void> clearCachedUser();
}

class UserLocalDataSourceImpl implements UserLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const kCachedUsers = 'CACHED_USERS';

  UserLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheUser(UserModel user) async {
    await sharedPreferences.setString(kCachedUsers, jsonEncode(user.toJson()));
  }

  @override
  Future<UserModel?> getCachedUser() async {
    final jsonString = sharedPreferences.getString(kCachedUsers);
    if (jsonString != null) {
      try {
        final jsonData = jsonDecode(jsonString);
        return UserModel.fromJson(jsonData);
      } on Exception catch (_) {
        // debugPrint(e.toString());
        return null;
      }
    }
    return null;
  }

  @override
  Future<void> clearCachedUser() async {
    await sharedPreferences.remove(kCachedUsers);
  }
}
