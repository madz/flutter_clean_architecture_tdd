import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:clean_architecture/core/error/failures.dart';
import 'package:clean_architecture/core/usecase/usecase.dart';
import 'package:clean_architecture/core/util/input_converter.dart';
import 'package:clean_architecture/features/news_list/domain/entities/news.dart';
import 'package:clean_architecture/features/news_list/domain/usecases/fetch_top_headlines.dart';
import 'package:clean_architecture/features/news_list/domain/usecases/fetch_top_headlines_by_keyword.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'bloc.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid Input - The number must be a positive integer or zero.';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final FetchTopHeadlinesUseCase fetchNewsHeadlines;
  final FetchTopHeadlinesByKeywordUseCase fetchNewsHeadlinesByKeyword;
  final InputConverter inputConverter;

  NewsBloc({
    @required this.fetchNewsHeadlines,
    @required this.fetchNewsHeadlinesByKeyword,
    @required this.inputConverter,
  })  : assert(fetchNewsHeadlines != null),
        assert(fetchNewsHeadlinesByKeyword != null),
        assert(inputConverter != null);
  @override
  NewsState get initialState => EmptyNewsState();

  @override
  Stream<NewsState> mapEventToState(
    NewsEvent event,
  ) async* {
    if (event is FetchNewsHeadlinesByKeywordEvent) {
      final inputEither = inputConverter.stringToUnsignedInteger("1");

      yield* inputEither.fold(
        (failure) async* {
          yield ErrorNewsState(message: INVALID_INPUT_FAILURE_MESSAGE);
        },
        (integer) async* {
          yield LoadingNewsState();
          final failureOrNewsList =
              await fetchNewsHeadlinesByKeyword(Params(keyword: 'Google'));
          yield* _eitherLoadedOrErrorState(failureOrNewsList);
        },
      );
    } else if (event is FetchNewsHeadlinesEvent) {
      yield LoadingNewsState();
      final failureOrTrivia = await fetchNewsHeadlines(NoParams());
      yield* _eitherLoadedOrErrorState(failureOrTrivia);
    }
  }

  Stream<NewsState> _eitherLoadedOrErrorState(
    Either<Failure, List<News>> failureOrNewsList,
  ) async* {
    yield failureOrNewsList.fold(
      (failure) => ErrorNewsState(message: _mapFailureToMessage(failure)),
      (listNews) => LoadedNewsState(listNews: listNews),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected error';
    }
  }
}
