import 'package:clean_architecture/features/news_list/presentation/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchKeywordWidget extends StatefulWidget {
  @override
  _SearchKeywordWidgetState createState() => _SearchKeywordWidgetState();
}

class _SearchKeywordWidgetState extends State<SearchKeywordWidget> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onSubmitted: (value) {
        if (value.isNotEmpty) {
          print('enter pressed');
          BlocProvider.of<NewsBloc>(context)
              .add(FetchNewsHeadlinesByKeywordEvent(keyword: value));
        }
      },
      decoration: InputDecoration(
        labelText: 'Enter search term',
        icon: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(Icons.search),
        ),
        suffixIcon: IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            print('suffixIcon pressed');
            _controller.clear();
          },
        ),
      ),
    );
  }
}
