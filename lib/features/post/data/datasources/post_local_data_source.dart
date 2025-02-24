import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/errors/exceptions.dart';
import '../models/post_model.dart';

abstract class PostLocalDataSource {
  Future<List<PostModel>> getCachedPosts();
  Future<void> cachePosts(List<PostModel> postsToCache);
}

const kCachedPost = 'CACHED_POSTS';

class PostLocalDataSourceImpl implements PostLocalDataSource {
  final SharedPreferences sharedPreferences;

  PostLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<PostModel>> getCachedPosts() {
    final jsonString = sharedPreferences.getString(kCachedPost);
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      return Future.value(jsonList.map((e) => PostModel.fromJson(e)).toList());
    } else {
      throw CacheException(message: "No Cached Post Found");
    }
  }

  @override
  Future<void> cachePosts(List<PostModel> postsToCache) {
    final List<Map<String, dynamic>> jsonList = postsToCache.map((e) => e.toJson()).toList();
    return sharedPreferences.setString(kCachedPost, json.encode(jsonList));
  }
}
