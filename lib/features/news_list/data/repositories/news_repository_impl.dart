import 'package:clean_architecture/core/error/exceptions.dart';
import 'package:clean_architecture/core/error/failures.dart';
import 'package:clean_architecture/core/network/network_info.dart';
import 'package:clean_architecture/features/news_list/data/datasources/news_local_data_source.dart';
import 'package:clean_architecture/features/news_list/data/datasources/news_remote_data_source.dart';
import 'package:clean_architecture/features/news_list/data/models/news_model.dart';
import 'package:clean_architecture/features/news_list/domain/repositories/news_repository.dart';
import 'package:meta/meta.dart';
import 'package:dartz/dartz.dart';

typedef Future<List<NewsModel>> _TopHeadlinesByKeywordOrNot();

class NewsRepositoryImpl implements NewsRepository {
  final NewsRemoteDataSource remoteDataSource;
  final NewsLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  NewsRepositoryImpl(
      {@required this.remoteDataSource,
      @required this.localDataSource,
      @required this.networkInfo});

  Future<Either<Failure, List<NewsModel>>> getTopHeadlinesByKeywordOrNot(
      String keyword) async {
    return await _getTopHeadlines(() {
      return remoteDataSource.fetchTopHeadLinesByKeyword(keyword: keyword);
    });
  }

  @override
  Future<Either<Failure, List<NewsModel>>> fetchTopHeadLines() async {
    return await _getTopHeadlines(() {
      return remoteDataSource.fetchTopHeadLines();
    });
  }

  @override
  Future<Either<Failure, List<NewsModel>>> fetchTopHeadLinesByKeyword(
      {String keyword}) async {
    return await _getTopHeadlines(() {
      return remoteDataSource.fetchTopHeadLinesByKeyword(keyword: keyword);
    });
  }

  Future<Either<Failure, List<NewsModel>>> _getTopHeadlines(
    _TopHeadlinesByKeywordOrNot getTopHeadlinesByKeywordOrNot,
  ) async {
    final isConnected = await networkInfo.isConnected;
    if (isConnected) {
      try {
        final remoteHeadlines = await getTopHeadlinesByKeywordOrNot();

        await localDataSource.cacheHeadlines(remoteHeadlines);

        return Right(remoteHeadlines);
      } on ServerExceptions {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localCacheHeadlines =
            await localDataSource.fetchCachedHeadLines();
        return Right(localCacheHeadlines);
      } on CacheExceptions {
        return Left(CacheFailure());
      }
    }
  }
}
