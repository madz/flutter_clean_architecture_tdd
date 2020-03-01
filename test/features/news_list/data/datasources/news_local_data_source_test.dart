import 'dart:convert';

import 'package:clean_architecture/core/error/exceptions.dart';
import 'package:clean_architecture/features/news_list/data/datasources/news_local_data_source.dart';
import 'package:clean_architecture/features/news_list/data/models/news_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/news_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  NewsLocalDataSourceImpl newsLocalDataSourceImpl;
  MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    newsLocalDataSourceImpl =
        NewsLocalDataSourceImpl(sharedPreferences: mockSharedPreferences);
  });

  group('fetchTopHeadLinesCache', () {
    final Map<String, dynamic> jsonMap = jsonDecode(fixture('news_cache.json'));
    final Iterable json = jsonMap['articles'];
    final tNewsModelList =
        json.map((news) => NewsModel.fromJson(news)).toList();

    test(
        'should return News from SharedPreferences when there is one in the cache.',
        () async {
      //arrange
      when(mockSharedPreferences.getString(any))
          .thenReturn(fixture('news_cache.json'));
      //act
      final result = await newsLocalDataSourceImpl.fetchCachedHeadLines();
      //assert
      verify(mockSharedPreferences.getString(CACHED_HEADLINES));
      expect(result, equals(tNewsModelList));
    });

    test('should throw a CacheException when there is not a cached value.',
        () async {
      //arrange
      when(mockSharedPreferences.getString(any)).thenReturn(null);
      //act
      final call = newsLocalDataSourceImpl.fetchCachedHeadLines;

      //assert
      expect(() => call(), throwsA(isInstanceOf<CacheExceptions>()));
    });

    test('should call SharedPreferences to cache the data.', () async {
      List<NewsModel> testListNewsList = [];
      final tNewsListModel = NewsModel(
          title:
              'The Boy Scouts of America files for bankruptcy amidst sexual harassment allegations - ABC News',
          url: 'https://www.youtube.com/watch?v=JSrXIZfHxEI',
          urlToImage: 'https://i.ytimg.com/vi/JSrXIZfHxEI/maxresdefault.jpg');
      testListNewsList.add(tNewsListModel);

      //act
      await newsLocalDataSourceImpl.cacheHeadlines(testListNewsList);
      //assert

      final expectedCachedJson =
          jsonEncode(testListNewsList.map((i) => i.toJson()).toList())
              .toString();

      verify(mockSharedPreferences.setString(
          CACHED_HEADLINES, expectedCachedJson));
    });
  });
}
