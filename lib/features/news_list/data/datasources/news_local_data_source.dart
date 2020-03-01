import 'dart:convert';

import 'package:clean_architecture/core/error/exceptions.dart';
import 'package:clean_architecture/features/news_list/data/models/news_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meta/meta.dart';

abstract class NewsLocalDataSource {
  ///Gets the cached [NewsModel] which was gotten the last time
  ///the user had an internet connection.
  ///
  /// Throws [CacheException] if no cached data is present;
  Future<void> cacheHeadlines(List<NewsModel> newsList);
  Future<List<NewsModel>> fetchCachedHeadLines();
}

const CACHED_HEADLINES = 'CACHED_HEADLINES';

class NewsLocalDataSourceImpl implements NewsLocalDataSource {
  final SharedPreferences sharedPreferences;

  NewsLocalDataSourceImpl({@required this.sharedPreferences});

  @override
  Future<void> cacheHeadlines(List<NewsModel> newsList) {
    final cachedJson =
        json.encode(newsList.map((i) => i.toJson()).toList()).toString();
    return sharedPreferences.setString(
      CACHED_HEADLINES,
      cachedJson,
    );
  }

  @override
  Future<List<NewsModel>> fetchCachedHeadLines() {
    final jsonString = sharedPreferences.getString(CACHED_HEADLINES);
    if (jsonString != null) {
      final json = jsonDecode(jsonString);
      final Iterable newsIterator = json['articles'];
      return Future.value(
        newsIterator.map((news) => NewsModel.fromJson(news)).toList(),
      );
    } else {
      throw CacheExceptions();
    }
  }
}
