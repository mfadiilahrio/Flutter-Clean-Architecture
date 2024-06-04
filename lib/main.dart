import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'presentation/pages/article_page.dart';

void main() {
  initializeDateFormatting('id_ID', null).then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Celebrities.id',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: ArticlePage(), // Replace with your initial page
    );
  }
}