import 'package:flutter/material.dart';
import 'presentation/pages/article_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Celebrities.Id',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ArticlePage(),
    );
  }
}