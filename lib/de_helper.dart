import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static Future<Database> db() async {
    return openDatabase(
      join(await getDatabasesPath(), "mydb.db"),
      version: 2,
      onCreate: (db, version) {
        db.execute("""CREATE TABLE IF NOT EXISTS note(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT,
          description TEXT,
          date TEXT
        )""");
      },
    );
  }

  static Future<int> addNote(
      {String? title, required String description}) async {
    final db = await DbHelper.db();
    return db.insert("note", {
      "title": title,
      "description": description,
      "date": DateTime.now().toString().split(".")[0]
    });
  }

  static Future<List<Map<String, dynamic>>> getAll() async {
    final db = await DbHelper.db();
    return db.query("note");
  }

  static Future<int> updateInfo(
      {required int id, String? title, String? description}) async {
    final db = await DbHelper.db();
    return db.update("note", {"title": title, "description": description},
        where: "id = ?", whereArgs: [id]);
  }

  static Future<int> deleteInfo(int id) async {
    final db = await DbHelper.db();
    return db.delete("note", where: "id = ? ", whereArgs: [id]);
  }
}
