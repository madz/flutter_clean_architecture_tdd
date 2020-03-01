import 'package:clean_architecture/core/error/failures.dart';
import 'package:clean_architecture/features/news_list/domain/entities/news.dart';
import 'package:dartz/dartz.dart';

abstract class NewsRepository {
  Future<Either<Failure, List<News>>> fetchTopHeadLinesByKeyword(
      {String keyword});

  Future<Either<Failure, List<News>>> fetchTopHeadLines();
}
