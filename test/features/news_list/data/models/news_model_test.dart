import 'dart:convert';

import 'package:clean_architecture/features/news_list/data/models/news_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/news_reader.dart';

void main() {
  List<NewsModel> testListNewsList = [];
  final tNewsListModel = NewsModel(
      title:
          'The Boy Scouts of America files for bankruptcy amidst sexual harassment allegations - ABC News',
      url: 'https://www.youtube.com/watch?v=JSrXIZfHxEI',
      urlToImage: 'https://i.ytimg.com/vi/JSrXIZfHxEI/maxresdefault.jpg');
  testListNewsList.add(tNewsListModel);

  test(
    'should be a subclass of NewsListModel entity',
    () async {
      // arrange
      // act
      // assert
      expect(tNewsListModel, isA<NewsModel>());
    },
  );

  group('fromJson', () {
    test(
      'should return a valid model when the JSON is returned',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap = jsonDecode(fixture('news.json'));
        final Iterable json = jsonMap['articles'];

        // act
        final result = json.map((news) => NewsModel.fromJson(news)).toList();

        // assert
        expect(result, testListNewsList);
      },
    );
  });

  group('toJson', () {
    test(
      'should return a json when the model is returned',
      () async {
        // arrange
        // act
        final result = tNewsListModel.toJson();

        // assert
        final expectedMap = {
          "title":
              "The Boy Scouts of America files for bankruptcy amidst sexual harassment allegations - ABC News",
          "url": "https://www.youtube.com/watch?v=JSrXIZfHxEI",
          "urlToImage": "https://i.ytimg.com/vi/JSrXIZfHxEI/maxresdefault.jpg",
        };
        expect(result, expectedMap);
      },
    );
  });
}
