// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewsModel _$NewsModelFromJson(Map<String, dynamic> json) {
  return NewsModel(
    title: json['title'],
    url: json['url'],
    urlToImage: json['urlToImage'],
  );
}

Map<String, dynamic> _$NewsModelToJson(NewsModel instance) => <String, dynamic>{
      'title': instance.title,
      'url': instance.url,
      'urlToImage': instance.urlToImage,
    };
