import 'package:clean_architecture/features/news_list/domain/entities/news.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class NewsState extends Equatable {
  const NewsState();
  @override
  List<Object> get props => [];
}

class EmptyNewsState extends NewsState {}

class LoadingNewsState extends NewsState {}

class LoadedNewsState extends NewsState {
  final List<News> listNews;

  LoadedNewsState({@required this.listNews});

  @override
  List<Object> get props => [listNews];
}

class ErrorNewsState extends NewsState {
  final String message;

  ErrorNewsState({@required this.message});

  @override
  List<Object> get props => [message];
}
