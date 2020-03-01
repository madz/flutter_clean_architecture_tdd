import 'package:clean_architecture/features/news_list/domain/entities/news.dart';
import 'package:clean_architecture/features/news_list/presentation/bloc/bloc.dart';
import 'package:clean_architecture/features/news_list/presentation/widgets/loading_widget.dart';
import 'package:clean_architecture/features/news_list/presentation/widgets/news_widget.dart';
import 'package:clean_architecture/features/news_list/presentation/widgets/search_keyword_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';
import 'news_article_detail_page.dart';

class NewsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Top News'),
      ),
      body: _buildBody(context),
    );
  }

  BlocProvider<NewsBloc> _buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<NewsBloc>(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SearchKeywordWidget(),
          BlocBuilder<NewsBloc, NewsState>(
            builder: (context, state) {
              if (state is LoadingNewsState) {
                return Expanded(
                  child: LoadingWidget(),
                );
              } else if (state is LoadedNewsState) {
                return Expanded(
                  child: NewsWidget(
                    news: state.listNews,
                    onTapArticle: (News news) {
                      _showNewsArticleDetails(context, news);
                    },
                  ),
                );
              } else if (state is EmptyNewsState) {
                return Expanded(
                  child: Align(
                    child: Text('No results found!'),
                  ),
                );
              } else {
                return Expanded(
                  child: Align(
                    child: Text(
                      'Something went wrong!',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  void _showNewsArticleDetails(BuildContext context, News news) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewsArticleDetailPage(news: news),
      ),
    );
  }
}
