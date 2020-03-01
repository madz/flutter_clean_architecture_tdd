import 'package:clean_architecture/features/news_list/domain/entities/news.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NewsArticleDetailPage extends StatelessWidget {
  final News news;
  NewsArticleDetailPage({this.news});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${this.news.title}'),
      ),
      body: Center(
        child: WebView(
          initialUrl: this.news.url,
        ),
      ),
    );
  }
}
