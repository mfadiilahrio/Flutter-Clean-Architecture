import 'dart:convert';

import 'package:celebrities/data/models/article_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'tables/articles_table.dart';
import 'tables/manual_articles_table.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    String path = join(await getDatabasesPath(), 'articles.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await ArticlesTable.createTable(db);
    await ManualArticlesTable.createTable(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await ManualArticlesTable.createTable(db);
    }
  }

  Future<void> insertArticle(ArticleModel article) async {
    final db = await database;
    await ArticlesTable.insertArticle(db, article.toJson());
  }

  Future<void> insertManualArticle(ArticleModel article) async {
    final db = await database;
    await ManualArticlesTable.insertArticle(db, article.toJson());
  }

  Future<List<ArticleModel>> getArticles() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await ArticlesTable.getArticles(db);
    return _mapListToArticleModelList(maps);
  }

  Future<List<ArticleModel>> getManualArticles() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await ManualArticlesTable.getArticles(db);
    return _mapListToArticleModelList(maps);
  }

  Future<void> deleteAllArticles() async {
    final db = await database;
    await ArticlesTable.deleteAllArticles(db);
  }

  Future<void> deleteAllManualArticles() async {
    final db = await database;
    await ManualArticlesTable.deleteAllArticles(db);
  }

  List<ArticleModel> _mapListToArticleModelList(List<Map<String, dynamic>> maps) {
    return List.generate(maps.length, (i) {
      var jsonMap = Map<String, dynamic>.from(maps[i]);
      jsonMap['slideshow'] = jsonDecode(jsonMap['slideshow']);
      return ArticleModel.fromJson(jsonMap);
    });
  }
}