import 'package:clean_architecture/core/error/exceptions.dart';
import 'package:clean_architecture/core/error/failures.dart';
import 'package:clean_architecture/core/network/network_info.dart';
import 'package:clean_architecture/features/news_list/data/datasources/news_local_data_source.dart';
import 'package:clean_architecture/features/news_list/data/datasources/news_remote_data_source.dart';
import 'package:clean_architecture/features/news_list/data/models/news_model.dart';
import 'package:clean_architecture/features/news_list/data/repositories/news_repository_impl.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockRemoteDataSource extends Mock implements NewsRemoteDataSource {}

class MockLocalDataSource extends Mock implements NewsLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  NewsRepositoryImpl newsRepositoryImpl;
  MockRemoteDataSource mockRemoteDataSource;
  MockLocalDataSource mockLocalDataSource;
  MockNetworkInfo mockNetworkInfo;

  String tKeyword;
  NewsModel tNewsModel;
  List<NewsModel> testListNewsModelList = [];

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();

    newsRepositoryImpl = NewsRepositoryImpl(
        remoteDataSource: mockRemoteDataSource,
        localDataSource: mockLocalDataSource,
        networkInfo: mockNetworkInfo);

    tKeyword = 'Google';
    tNewsModel = NewsModel(
        title: 'Google',
        url: 'https://www.example.com',
        urlToImage: 'https://www.image.com');
    testListNewsModelList.add(tNewsModel);
  });

  void runTestsOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      body();
    });
  }

  void runTestsOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      body();
    });
  }

  ///
  ///  fetchTopHeadLinesByKeyword
  ///
  group('fetchTopHeadLinesByKeyword', () {
    test('should check if the device is online', () async {
      //arrange
      when(mockNetworkInfo.isConnected)
          .thenAnswer((realInvocation) async => true);
      //act
      await newsRepositoryImpl.fetchTopHeadLinesByKeyword(keyword: tKeyword);
      //assert
      verify(mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      test(
          'should return remote data when the call to remote data source is successfull',
          () async {
        when(
          mockRemoteDataSource.fetchTopHeadLinesByKeyword(keyword: tKeyword),
        ).thenAnswer((realInvocation) async => testListNewsModelList);

        //act
        var result = await newsRepositoryImpl.fetchTopHeadLinesByKeyword(
            keyword: tKeyword);
        //assert
        verify(
            mockRemoteDataSource.fetchTopHeadLinesByKeyword(keyword: tKeyword));
        expect(
          result,
          equals(
            Right(testListNewsModelList),
          ),
        );
      });

      test(
          'should cache the data locally when the call to remote data source is successfull',
          () async {
        when(
          mockRemoteDataSource.fetchTopHeadLinesByKeyword(keyword: tKeyword),
        ).thenAnswer((realInvocation) async => testListNewsModelList);
        //act
        await newsRepositoryImpl.fetchTopHeadLinesByKeyword(keyword: tKeyword);
        //assert
        verify(
            mockRemoteDataSource.fetchTopHeadLinesByKeyword(keyword: tKeyword));

        verify(mockLocalDataSource.cacheHeadlines(testListNewsModelList));
      });

      test(
          'should return server failure when the call to remove data source is unsuccesful',
          () async {
        //arrange
        when(
          mockRemoteDataSource.fetchTopHeadLinesByKeyword(keyword: tKeyword),
        ).thenThrow(ServerExceptions());
        //act
        final result = await newsRepositoryImpl.fetchTopHeadLinesByKeyword(
            keyword: tKeyword);
        //assert
        verify(
            mockRemoteDataSource.fetchTopHeadLinesByKeyword(keyword: tKeyword));
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(Left(ServerFailure())));
      });
    });

    runTestsOffline(() {
      test(
          'should return last locally cached data when the cached data is present',
          () async {
        //arrange
        when(mockLocalDataSource.fetchCachedHeadLines())
            .thenAnswer((realInvocation) async => testListNewsModelList);
        //act
        final result = await newsRepositoryImpl.fetchTopHeadLinesByKeyword(
            keyword: tKeyword);
        //assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.fetchCachedHeadLines());
        expect(result, equals(Right(testListNewsModelList)));
      });
    });

    runTestsOffline(() {
      test('should return CacheFailure when there is no cached data present.',
          () async {
        //arrange
        when(mockLocalDataSource.fetchCachedHeadLines())
            .thenThrow(CacheExceptions());
        //act
        final result = await newsRepositoryImpl.fetchTopHeadLinesByKeyword(
            keyword: tKeyword);
        //assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.fetchCachedHeadLines());
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });

  ///
  /// fetchTopHeadLines
  ///
  group('fetchTopHeadLines', () {
    test('should check if the device is online', () async {
      //arrange
      when(mockNetworkInfo.isConnected)
          .thenAnswer((realInvocation) async => true);
      //act
      await newsRepositoryImpl.fetchTopHeadLines();
      //assert
      verify(mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      test(
          'should return remote data when the call to remote data source is successfull',
          () async {
        when(
          mockRemoteDataSource.fetchTopHeadLines(),
        ).thenAnswer((realInvocation) async => testListNewsModelList);

        //act
        var result = await newsRepositoryImpl.fetchTopHeadLines();
        //assert
        verify(mockRemoteDataSource.fetchTopHeadLines());
        expect(
          result,
          equals(
            Right(testListNewsModelList),
          ),
        );
      });

      test(
          'should cache the data locally when the call to remote data source is successfull',
          () async {
        when(
          mockRemoteDataSource.fetchTopHeadLines(),
        ).thenAnswer((realInvocation) async => testListNewsModelList);
        //act
        await newsRepositoryImpl.fetchTopHeadLines();
        //assert
        verify(mockRemoteDataSource.fetchTopHeadLines());

        verify(mockLocalDataSource.cacheHeadlines(testListNewsModelList));
      });

      test(
          'should return server failure when the call to remove data source is unsuccesful',
          () async {
        //arrange
        when(
          mockRemoteDataSource.fetchTopHeadLines(),
        ).thenThrow(ServerExceptions());
        //act
        final result = await newsRepositoryImpl.fetchTopHeadLines();
        //assert
        verify(mockRemoteDataSource.fetchTopHeadLines());
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(Left(ServerFailure())));
      });
    });

    runTestsOffline(() {
      test(
          'should return last locally cached data when the cached data is present',
          () async {
        //arrange
        when(mockLocalDataSource.fetchCachedHeadLines())
            .thenAnswer((realInvocation) async => testListNewsModelList);
        //act
        final result = await newsRepositoryImpl.fetchTopHeadLines();
        //assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.fetchCachedHeadLines());
        expect(result, equals(Right(testListNewsModelList)));
      });
    });

    runTestsOffline(() {
      test('should return CacheFailure when there is no cached data present.',
          () async {
        //arrange
        when(mockLocalDataSource.fetchCachedHeadLines())
            .thenThrow(CacheExceptions());
        //act
        final result = await newsRepositoryImpl.fetchTopHeadLines();
        //assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.fetchCachedHeadLines());
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });
}
