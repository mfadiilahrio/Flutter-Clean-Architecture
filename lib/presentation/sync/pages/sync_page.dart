import 'package:flutter/material.dart';
import 'package:celebrities/data/local/db/database_helper.dart';
import 'package:celebrities/data/models/article_model.dart';
import 'package:celebrities/presentation/article/widgets/article_widget.dart';

class SyncPage extends StatefulWidget {
  @override
  _SyncPageState createState() => _SyncPageState();
}

class _SyncPageState extends State<SyncPage> {
  late Future<List<ArticleModel>> _manualArticlesFuture;

  @override
  void initState() {
    super.initState();
    _manualArticlesFuture = _fetchManualArticles();
  }

  Future<List<ArticleModel>> _fetchManualArticles() async {
    final dbHelper = DatabaseHelper();
    return await dbHelper.getManualArticles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Offline'),
      ),
      body: FutureBuilder<List<ArticleModel>>(
        future: _manualArticlesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Tidak ada artikel tersimpan'));
          } else {
            final articles = snapshot.data!;
            return ListView.separated(
              itemCount: articles.length,
              itemBuilder: (context, index) {
                final article = articles[index];
                return ArticleWidget(article: article.toEntity());
              },
              separatorBuilder: (context, index) => Divider(),
            );
          }
        },
      ),
    );
  }
}