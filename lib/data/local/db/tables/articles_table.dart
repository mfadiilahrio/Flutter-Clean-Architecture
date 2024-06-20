import 'package:sqflite/sqflite.dart';

class ArticlesTable {
  static const String tableName = 'articles';

  static Future<void> createTable(Database db) async {
    await db.execute('''
      CREATE TABLE $tableName(
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

  static Future<void> insertArticle(Database db, Map<String, dynamic> article) async {
    await db.insert(
      tableName,
      article,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getArticles(Database db) async {
    return await db.query(tableName);
  }

  static Future<void> deleteAllArticles(Database db) async {
    await db.delete(tableName);
  }
}