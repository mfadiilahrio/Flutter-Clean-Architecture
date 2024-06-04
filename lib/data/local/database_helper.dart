import 'dart:convert';
import 'package:celebrities/data/models/article_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

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
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE articles(
        id TEXT PRIMARY KEY,
        title TEXT,
        content TEXT,
        contentThumbnail TEXT,
        contributorName TEXT,
        createdAt TEXT,
        slideshow TEXT
      )
    ''');
  }

  Future<void> insertArticle(ArticleModel article) async {
    final db = await database;
    await db.insert(
      'articles',
      article.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<ArticleModel>> getArticles() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('articles');

    return List.generate(maps.length, (i) {
      var jsonMap = Map<String, dynamic>.from(maps[i]); // Make a mutable copy
      jsonMap['slideshow'] = jsonDecode(jsonMap['slideshow']);
      return ArticleModel.fromJson(jsonMap);
    });
  }

  Future<void> deleteAllArticles() async {
    final db = await database;
    await db.delete('articles');
  }
}