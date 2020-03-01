import 'package:equatable/equatable.dart';

abstract class NewsEvent extends Equatable {
  const NewsEvent();
  @override
  List<Object> get props => [];
}

class FetchNewsHeadlinesEvent extends NewsEvent {
  const FetchNewsHeadlinesEvent();
}

class FetchNewsHeadlinesByKeywordEvent extends NewsEvent {
  final String keyword;
  const FetchNewsHeadlinesByKeywordEvent({this.keyword});

  @override
  List<Object> get props => [keyword];
}
