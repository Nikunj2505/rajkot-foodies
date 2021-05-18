import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sqlite;
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static const DB_NAME = "foodies.db";
  static const FOOD_GALLERY_TABLE = "food_gallery";

  static Future<Database> _getDatabase() async {
    final dbPath = await sqlite.getDatabasesPath();
    String path = join(dbPath, DB_NAME);
    return sqlite.openDatabase(
      path,
      onCreate: (db, version) {
        return db.execute(
            "CREATE TABLE $FOOD_GALLERY_TABLE (id INTEGER PRIMARY KEY AUTOINCREMENT, path TEXT)");
      },
      version: 1,
    );
  }

  static Future<int> insertFoodImages(Map<String, dynamic> map) async {
    final db = await DBHelper._getDatabase();
    return db.insert(FOOD_GALLERY_TABLE, map);
  }

  static Future<List<Map<String, dynamic>>> getAllFoodImages() async {
    final db = await DBHelper._getDatabase();
    return db.query(
      FOOD_GALLERY_TABLE, /*orderBy: 'id DESC'*/
    );
  }
}
