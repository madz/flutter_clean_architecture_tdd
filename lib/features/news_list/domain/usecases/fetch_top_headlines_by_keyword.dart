import 'package:clean_architecture/core/error/failures.dart';
import 'package:clean_architecture/core/usecase/usecase.dart';
import 'package:clean_architecture/features/news_list/domain/entities/news.dart';
import 'package:clean_architecture/features/news_list/domain/repositories/news_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class FetchTopHeadlinesByKeywordUseCase implements UseCase<List<News>, Params> {
  final NewsRepository newsListRepository;

  FetchTopHeadlinesByKeywordUseCase(this.newsListRepository);

  @override
  Future<Either<Failure, List<News>>> call(Params params) async {
    return await newsListRepository.fetchTopHeadLinesByKeyword(
        keyword: params.keyword);
  }
}

class Params extends Equatable {
  final String keyword;

  Params({@required this.keyword});

  @override
  List<Object> get props => [keyword];
}
