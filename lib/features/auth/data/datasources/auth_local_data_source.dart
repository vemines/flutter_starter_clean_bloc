import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/auth_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheAuth(AuthModel auth);
  Future<AuthModel?> getCachedAuth();
  Future<void> clearCachedAuth();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage secureStorage;
  static const kCachedAuth = 'CACHED_AUTH';

  AuthLocalDataSourceImpl({required this.secureStorage});

  @override
  Future<void> cacheAuth(AuthModel auth) =>
      secureStorage.write(key: kCachedAuth, value: json.encode(auth.toJson()));

  @override
  Future<AuthModel?> getCachedAuth() async {
    final jsonString = await secureStorage.read(key: kCachedAuth);
    if (jsonString != null) {
      return AuthModel.fromJson(jsonDecode(jsonString));
    }
    return null;
  }

  @override
  Future<void> clearCachedAuth() => secureStorage.delete(key: kCachedAuth);
}
