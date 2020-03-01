import 'package:clean_architecture/features/news_list/domain/entities/news.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
part 'news_model.g.dart';

@JsonSerializable()
class NewsModel extends News {
  NewsModel({@required title, @required url, @required urlToImage})
      : super(title: title, url: url, urlToImage: urlToImage);

  factory NewsModel.fromJson(Map<String, dynamic> json) =>
      _$NewsModelFromJson(json);
  Map<String, dynamic> toJson() => _$NewsModelToJson(this);
}
