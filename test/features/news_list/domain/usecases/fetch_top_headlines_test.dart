import 'package:clean_architecture/core/usecase/usecase.dart';
import 'package:clean_architecture/features/news_list/domain/entities/news.dart';
import 'package:clean_architecture/features/news_list/domain/repositories/news_repository.dart';
import 'package:clean_architecture/features/news_list/domain/usecases/fetch_top_headlines.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockNewsListRepository extends Mock implements NewsRepository {}

void main() {
  FetchTopHeadlinesUseCase useCase;
  MockNewsListRepository mockNewsListRepository;

  List<News> tNewsList = [];
  News tNews;

  setUp(() {
    mockNewsListRepository = MockNewsListRepository();
    useCase = FetchTopHeadlinesUseCase(mockNewsListRepository);

    tNews = News(
        title: 'Google',
        url: 'https://www.example.com',
        urlToImage: 'https://www.image.com');
    tNewsList.add(tNews);
  });

  test(
    'should fetch headlines from the repository using keyword',
    () async {
      // arrange
      when(mockNewsListRepository.fetchTopHeadLines())
          .thenAnswer((_) async => Right(tNewsList));
      // act
      final result = await useCase(NoParams());

      // assert
      expect(result, Right(tNewsList));
      verify(mockNewsListRepository.fetchTopHeadLines());
      verifyNoMoreInteractions(mockNewsListRepository);
    },
  );
}
