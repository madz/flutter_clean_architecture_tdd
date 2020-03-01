import 'dart:convert';

import 'package:clean_architecture/core/constants/constants.dart';
import 'package:clean_architecture/core/error/exceptions.dart';
import 'package:clean_architecture/features/news_list/data/datasources/news_remote_data_source.dart';
import 'package:clean_architecture/features/news_list/data/models/news_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import '../../../../fixtures/news_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  NewsRemoteDataSourceImpl newsRemoteDataSourceImpl;
  MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    newsRemoteDataSourceImpl = NewsRemoteDataSourceImpl(client: mockHttpClient);
  });

  void setUpMockHttpClientSuccess200() {
    when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
        (realInvocation) async => http.Response(fixture('news.json'), 200));
  }

  void setUpMockHttpClientFailure404() {
    when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
        (realInvocation) async => http.Response('Something went wrong', 404));
  }

  group('fetchTopHeadLinesByKeyword', () {
    String tKeyword = 'Google';
    final Map<String, dynamic> jsonMap = jsonDecode(fixture('news.json'));
    final Iterable json = jsonMap['articles'];
    final tNewsModelList =
        json.map((news) => NewsModel.fromJson(news)).toList();

    test(
        'should perform a GET request on a URL with keyword '
        'and application/json header.', () async {
      //arrange
      setUpMockHttpClientSuccess200();
      //act
      await newsRemoteDataSourceImpl.fetchTopHeadLinesByKeyword(
          keyword: tKeyword);
      //assert
      verify(mockHttpClient.get(
          Constants.headLinesByKeywordURL(keyword: tKeyword),
          headers: {'Content-Type': 'application/json'}));
    });

    test('should returneds List of News when the response code is 200',
        () async {
      //arrange
      setUpMockHttpClientSuccess200();
      //act
      final result = await newsRemoteDataSourceImpl.fetchTopHeadLinesByKeyword(
          keyword: tKeyword);
      //assert
      expect(result, equals(tNewsModelList));
    });

    test(
        'should throw a ServerException when the response code is 404 or other.',
        () async {
      //arrange
      setUpMockHttpClientFailure404();
      //act
      final call = newsRemoteDataSourceImpl.fetchTopHeadLinesByKeyword(
          keyword: tKeyword);

      //assert
      expect(() => call, throwsA(isInstanceOf<ServerExceptions>()));
    });
  });

  group('fetchTopHeadLines', () {
    final Map<String, dynamic> jsonMap = jsonDecode(fixture('news.json'));
    final Iterable json = jsonMap['articles'];
    final tNewsModelList =
        json.map((news) => NewsModel.fromJson(news)).toList();

    test(
        'should perform a GET request on a URL with keyword '
        'and application/json header.', () async {
      //arrange
      setUpMockHttpClientSuccess200();
      //act
      await newsRemoteDataSourceImpl.fetchTopHeadLines();
      //assert
      verify(mockHttpClient.get(Constants.topHeadLinesURL(),
          headers: {'Content-Type': 'application/json'}));
    });

    test('should returneds List of News when the response code is 200',
        () async {
      //arrange
      setUpMockHttpClientSuccess200();
      //act
      final result = await newsRemoteDataSourceImpl.fetchTopHeadLines();
      //assert
      expect(result, equals(tNewsModelList));
    });

    test(
        'should throw a ServerException when the response code is 404 or other.',
        () async {
      //arrange
      setUpMockHttpClientFailure404();
      //act
      final call = newsRemoteDataSourceImpl.fetchTopHeadLines();

      //assert
      expect(() => call, throwsA(isInstanceOf<ServerExceptions>()));
    });
  });
}
