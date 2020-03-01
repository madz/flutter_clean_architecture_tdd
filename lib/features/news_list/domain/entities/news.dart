import 'package:equatable/equatable.dart';

class News extends Equatable {
  final String title;
  final String url;
  final String urlToImage;

  News({this.title, this.url, this.urlToImage});

  @override
  List<Object> get props => [title, url, urlToImage];
}
