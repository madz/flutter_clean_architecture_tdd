import 'dart:convert';

import 'package:clean_architecture/core/constants/constants.dart';
import 'package:clean_architecture/core/error/exceptions.dart';
import 'package:clean_architecture/features/news_list/data/models/news_model.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

abstract class NewsRemoteDataSource {
  /// Calls the 'https://newsapi.org/v2/everything?q={keyword}' endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<List<NewsModel>> fetchTopHeadLinesByKeyword(
      {@required String keyword});

  /// Calls the 'https://newsapi.org/v2/top-headlines?country=us endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<List<NewsModel>> fetchTopHeadLines();
}

class NewsRemoteDataSourceImpl implements NewsRemoteDataSource {
  final http.Client client;

  NewsRemoteDataSourceImpl({@required this.client});

  @override
  Future<List<NewsModel>> fetchTopHeadLines() async {
    return await _getTopHeadlinesFromUrl(Constants.topHeadLinesURL());
  }

  @override
  Future<List<NewsModel>> fetchTopHeadLinesByKeyword({String keyword}) async {
    return await _getTopHeadlinesFromUrl(
        Constants.headLinesByKeywordURL(keyword: keyword));
  }

  Future<List<NewsModel>> _getTopHeadlinesFromUrl(String url) async {
    final response = await client.get(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      final Iterable json = result['articles'];
      final listNewsModel =
          json.map((movie) => NewsModel.fromJson(movie)).toList();

      return listNewsModel;
    } else {
      throw ServerExceptions();
    }
  }
}
