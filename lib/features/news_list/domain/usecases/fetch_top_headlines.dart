import 'package:clean_architecture/core/error/failures.dart';
import 'package:clean_architecture/core/usecase/usecase.dart';
import 'package:clean_architecture/features/news_list/domain/entities/news.dart';
import 'package:clean_architecture/features/news_list/domain/repositories/news_repository.dart';
import 'package:dartz/dartz.dart';

class FetchTopHeadlinesUseCase implements UseCase<List<News>, NoParams> {
  final NewsRepository newsListRepository;

  FetchTopHeadlinesUseCase(this.newsListRepository);

  @override
  Future<Either<Failure, List<News>>> call(NoParams params) async {
    return await newsListRepository.fetchTopHeadLines();
  }
}
