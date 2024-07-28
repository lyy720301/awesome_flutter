import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../model/word.dart';

class WordDataBase {
  static WordDataBase? _instance;

  late Database database;

  WordDataBase._create(Database db) {
    database = db;
  }

  static Future<WordDataBase> getInstance() async {
    if (_instance != null) {
      return _instance!;
    }
    WidgetsFlutterBinding.ensureInitialized();
    var db = await openDatabase(
      join(await getDatabasesPath(), 'history_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE words(id INTEGER PRIMARY KEY AUTOINCREMENT, first TEXT, second TEXT, like INTEGER)',
        );
      },
      version: 1,
    );
    _instance = WordDataBase._create(db);
    return _instance!;
  }

  Future<List<Word>> words() async {
    final db = database;

    final List<Map<String, Object?>> wordMaps = await db.query('words');

    return [
      for (final {
            'id': id as int,
            'first': first as String,
            'second': second as String,
            'like' : like as int,
          } in wordMaps)
        Word(id: id, first: first, second: second, like: like),
    ];
  }

  Future<void> insertWord(Word word) async {
    await database.insert(
      'words',
      word.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
