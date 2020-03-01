import 'package:clean_architecture/core/error/failures.dart';
import 'package:clean_architecture/core/usecase/usecase.dart';
import 'package:clean_architecture/core/util/input_converter.dart';
import 'package:clean_architecture/features/news_list/domain/entities/news.dart';
import 'package:clean_architecture/features/news_list/domain/usecases/fetch_top_headlines.dart';
import 'package:clean_architecture/features/news_list/domain/usecases/fetch_top_headlines_by_keyword.dart';
import 'package:clean_architecture/features/news_list/presentation/bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockFetchTopHeadlines extends Mock implements FetchTopHeadlinesUseCase {}

class MockFetchNewsHeadlinesByKeyword extends Mock
    implements FetchTopHeadlinesByKeywordUseCase {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  NewsBloc newsBloc;
  MockFetchTopHeadlines mockFetchTopHeadlines;
  MockFetchNewsHeadlinesByKeyword mockFetchNewsHeadlinesByKeyword;
  MockInputConverter mockInputConverter;

  String tTitle = 'Google';

  List<News> tNewsList = [];

  News tNews = News(
      title: tTitle,
      url: 'https://www.example.com',
      urlToImage: 'https://www.image.com');
  tNewsList.add(tNews);

  setUp(() {
    mockFetchTopHeadlines = MockFetchTopHeadlines();
    mockFetchNewsHeadlinesByKeyword = MockFetchNewsHeadlinesByKeyword();
    mockInputConverter = MockInputConverter();

    newsBloc = NewsBloc(
      fetchNewsHeadlines: mockFetchTopHeadlines,
      fetchNewsHeadlinesByKeyword: mockFetchNewsHeadlinesByKeyword,
      inputConverter: mockInputConverter,
    );
  });

  test('inital should be Empty', () {
    expect(newsBloc.initialState, equals(EmptyNewsState()));
  });

  group('FetchTopHeadlinesByKeywordUseCase', () {
    final tNumberString = '1';
    final tNumberParsed = 1;

    void setUpMockInputConverterSuccess() =>
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Right(tNumberParsed));

    test(
        'should call the InputConverter to validate '
        'and convert the string to an unssigned integer.', () async {
      // assign
      setUpMockInputConverterSuccess();
      // act
      newsBloc.add(FetchNewsHeadlinesByKeywordEvent());
      await untilCalled(mockInputConverter.stringToUnsignedInteger(any));

      // assert
      verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
    });

    test('should emit [ErrorNewsState] when the input is invalid.', () async {
      // assign
      when(mockInputConverter.stringToUnsignedInteger(any))
          .thenReturn(Left(InvalidInputFailure()));
      // act
      newsBloc.add(FetchNewsHeadlinesByKeywordEvent(keyword: tTitle));

      // assert later
      final expected = [
        EmptyNewsState(),
        ErrorNewsState(message: INVALID_INPUT_FAILURE_MESSAGE),
      ];
      await expectLater(newsBloc, emitsInOrder(expected));
      newsBloc.add(FetchNewsHeadlinesByKeywordEvent());
    });

    test('should get data from the FetchNewsHeadlinesByKeywordUseCase',
        () async {
      // assign
      setUpMockInputConverterSuccess();

      when(mockFetchNewsHeadlinesByKeyword(any))
          .thenAnswer((_) async => Right(tNewsList));
      // act
      newsBloc.add(FetchNewsHeadlinesByKeywordEvent(keyword: tTitle));
      await untilCalled(mockFetchNewsHeadlinesByKeyword(any));
      // assert
      verify(
        mockFetchNewsHeadlinesByKeyword(
          Params(keyword: tTitle),
        ),
      );
    });

    test('should emit [Loading, Loaded] when data is gotten succesfully.',
        () async {
      // assign
      setUpMockInputConverterSuccess();
      when(mockFetchNewsHeadlinesByKeyword(any))
          .thenAnswer((_) async => Right(tNewsList));

      // assert later
      final expected = [
        EmptyNewsState(),
        LoadingNewsState(),
        LoadedNewsState(listNews: tNewsList),
      ];

      await expectLater(newsBloc, emitsInOrder(expected));
      // act
      newsBloc.add(FetchNewsHeadlinesByKeywordEvent(keyword: tTitle));
    });

    test('should emit [Loading, Error] when getting data fails.', () async {
      // assign
      setUpMockInputConverterSuccess();

      when(mockFetchNewsHeadlinesByKeyword(any))
          .thenAnswer((_) async => Left(ServerFailure()));

      // assert later
      final expected = [
        EmptyNewsState(),
        LoadingNewsState(),
        ErrorNewsState(message: SERVER_FAILURE_MESSAGE),
      ];

      await expectLater(newsBloc, emitsInOrder(expected));
      // act
      newsBloc.add(FetchNewsHeadlinesByKeywordEvent(keyword: tTitle));
    });

    test(
        'should emit [Loading, Error] with proper message for the error when getting data fails.',
        () async {
      // assign
      setUpMockInputConverterSuccess();
      when(mockFetchNewsHeadlinesByKeyword(any))
          .thenAnswer((_) async => Left(CacheFailure()));

      // assert later
      final expected = [
        EmptyNewsState(),
        LoadingNewsState(),
        ErrorNewsState(message: CACHE_FAILURE_MESSAGE),
      ];

      await expectLater(newsBloc, emitsInOrder(expected));
      // act
      newsBloc.add(FetchNewsHeadlinesByKeywordEvent(keyword: tTitle));
    });
  });

  group('FetchTopHeadlines', () {
    test('should get data from the FetchTopHeadlines', () async {
      // arrange
      when(mockFetchTopHeadlines(any))
          .thenAnswer((_) async => Right(tNewsList));
      // act
      newsBloc.add(FetchNewsHeadlinesEvent());
      await untilCalled(mockFetchTopHeadlines(any));
      // assert
      verify(
        mockFetchTopHeadlines(
          NoParams(),
        ),
      );
    });

    test('should emit [Loading, Loaded] when data is gotten succesfully.',
        () async {
      // arrange
      when(mockFetchTopHeadlines(any))
          .thenAnswer((_) async => Right(tNewsList));

      // assert later
      final expected = [
        EmptyNewsState(),
        LoadingNewsState(),
        LoadedNewsState(listNews: tNewsList),
      ];

      await expectLater(newsBloc, emitsInOrder(expected));
      // act
      newsBloc.add(FetchNewsHeadlinesEvent());
    });

    test('should emit [Loading, Error] when getting data fails.', () async {
      // assign
      when(mockFetchNewsHeadlinesByKeyword(any))
          .thenAnswer((_) async => Left(ServerFailure()));

      // assert later
      final expected = [
        EmptyNewsState(),
        LoadingNewsState(),
        ErrorNewsState(message: SERVER_FAILURE_MESSAGE),
      ];

      await expectLater(newsBloc, emitsInOrder(expected));
      // act
      newsBloc.add(FetchNewsHeadlinesEvent());
    });

    test(
        'should emit [Loading, Error] with proper message for the error when getting data fails.',
        () async {
      // assign
      when(mockFetchNewsHeadlinesByKeyword(any))
          .thenAnswer((_) async => Left(CacheFailure()));

      // assert later
      final expected = [
        EmptyNewsState(),
        LoadingNewsState(),
        ErrorNewsState(message: CACHE_FAILURE_MESSAGE),
      ];

      await expectLater(newsBloc, emitsInOrder(expected));
      // act
      newsBloc.add(FetchNewsHeadlinesEvent());
    });
  });
}
