import 'package:clean_architecture/features/news_list/presentation/pages/news_page.dart';
import 'package:flutter/material.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News Page',
      theme: ThemeData(
        primaryColor: Colors.green.shade800,
        accentColor: Colors.green.shade600,
      ),
      home: NewsPage(),
    );
  }
}
