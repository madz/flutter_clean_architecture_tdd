import 'package:clean_architecture/features/news_list/domain/entities/news.dart';
import 'package:clean_architecture/features/news_list/domain/repositories/news_repository.dart';
import 'package:clean_architecture/features/news_list/domain/usecases/fetch_top_headlines_by_keyword.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockNewsRepository extends Mock implements NewsRepository {}

void main() {
  FetchTopHeadlinesByKeywordUseCase useCase;
  MockNewsRepository mockNewsRepository;

  String tTitle;

  List<News> tNewsList = [];
  News tNews;

  setUp(() {
    mockNewsRepository = MockNewsRepository();
    useCase = FetchTopHeadlinesByKeywordUseCase(mockNewsRepository);

    tTitle = 'Google';
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
      when(mockNewsRepository.fetchTopHeadLinesByKeyword(keyword: tTitle))
          .thenAnswer((_) async => Right(tNewsList));
      // act
      final result = await useCase(Params(keyword: tTitle));

      // assert
      expect(result, Right(tNewsList));
      verify(mockNewsRepository.fetchTopHeadLinesByKeyword(keyword: tTitle));
      verifyNoMoreInteractions(mockNewsRepository);
    },
  );
}
