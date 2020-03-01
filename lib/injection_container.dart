import 'package:clean_architecture/core/network/network_info.dart';
import 'package:clean_architecture/core/util/input_converter.dart';
import 'package:clean_architecture/features/news_list/data/datasources/news_local_data_source.dart';
import 'package:clean_architecture/features/news_list/data/datasources/news_remote_data_source.dart';
import 'package:clean_architecture/features/news_list/data/repositories/news_repository_impl.dart';
import 'package:clean_architecture/features/news_list/domain/repositories/news_repository.dart';
import 'package:clean_architecture/features/news_list/domain/usecases/fetch_top_headlines.dart';
import 'package:clean_architecture/features/news_list/domain/usecases/fetch_top_headlines_by_keyword.dart';
import 'package:clean_architecture/features/news_list/presentation/bloc/bloc.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;

Future<void> init() async {
  // Features - News
  sl.registerFactory(
    () => NewsBloc(
      fetchNewsHeadlines: sl(),
      fetchNewsHeadlinesByKeyword: sl(),
      inputConverter: sl(),
    ),
  );

  //Use Case
  sl.registerLazySingleton(
    () => FetchTopHeadlinesByKeywordUseCase(
      sl(),
    ),
  );
  sl.registerLazySingleton(
    () => FetchTopHeadlinesUseCase(
      sl(),
    ),
  );

  // Repository
  sl.registerLazySingleton<NewsRepository>(
    () => NewsRepositoryImpl(
      localDataSource: sl(),
      networkInfo: sl(),
      remoteDataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<NewsRemoteDataSource>(
    () => NewsRemoteDataSourceImpl(
      client: sl(),
    ),
  );

  sl.registerLazySingleton<NewsLocalDataSource>(
    () => NewsLocalDataSourceImpl(
      sharedPreferences: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => InputConverter(),
  );
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(sl()),
  );

  final sharedPreferences = await SharedPreferences.getInstance();

  sl.registerLazySingleton(
    () => sharedPreferences,
  );
  sl.registerLazySingleton(
    () => http.Client(),
  );
  sl.registerLazySingleton(
    () => DataConnectionChecker(),
  );
}
