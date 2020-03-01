import 'package:clean_architecture/features/news_list/domain/entities/news.dart';
import 'package:flutter/material.dart';

class NewsWidget extends StatelessWidget {
  final List<News> news;
  final Function(News article) onTapArticle;

  NewsWidget({this.news, this.onTapArticle});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: news == null ? 0 : news.length,
      itemBuilder: (context, index) {
        final article = news.elementAt(index);
        return ListTile(
          onTap: () {
            this.onTapArticle(article);
          },
          leading: Container(
            height: 100,
            width: 100,
            child: article?.urlToImage == null
                ? Image.asset("images/news.jpg")
                : Image.network(article?.urlToImage),
          ),
          title: Text(
            article?.title ?? "",
          ),
        );
      },
    );
  }
}
