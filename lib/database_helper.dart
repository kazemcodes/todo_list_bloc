import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_list_bloc/todo_controller.dart';

class DatabaseHelper {
  static String TABLE_NAME = 'todo';

  static final DatabaseHelper instance = DatabaseHelper._getInstance();
  static Database? _database;

  DatabaseHelper._getInstance();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory document = await getApplicationDocumentsDirectory();
    String path = join(document.path, 'todo.db');
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  void _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE IF NOT EXISTS $TABLE_NAME (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT,
    done INTEGER);
    ''');
  }

  Future<int> insert(TodoItem todoItem) async {
    Database db = await instance.database;
    return db.insert(TABLE_NAME, todoItem.toMap());
  }

  Future<int> delete(TodoItem todoItem) async {
    Database db = await instance.database;
    return db.delete(TABLE_NAME, where: 'id = ?', whereArgs: [todoItem.id]);
  }

  Future<int> update(TodoItem todoItem) async {
    Database db = await instance.database;
    return db.update(TABLE_NAME, todoItem.toMap(),
        where: 'id = ?', whereArgs: [todoItem.id]);
  }

  Future<List<TodoItem>> getTodos() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(TABLE_NAME);
    return List.generate(maps.length, (index) => TodoItem.fromMap(maps[index]));
  }
}
