import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:path/path.dart' as p;
import '../models/tarefa.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance =
      DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    if (kIsWeb) {
      databaseFactory = databaseFactoryFfiWeb;
    }

    const filePath = 'tarefas.db';

    final String path = kIsWeb
        ? filePath
        : p.join(await getDatabasesPath(), filePath);

    return databaseFactory.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE tarefas (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              titulo TEXT NOT NULL,
              concluida INTEGER NOT NULL
            )
          ''');
        },
      ),
    );
  }

  Future<List<Tarefa>> queryAll() async {
    final db = await database;
    final resultado = await db.query('tarefas', orderBy: 'id DESC');
    return resultado.map((mapa) => Tarefa.fromMap(mapa)).toList();
  }

  Future<int> insert(Tarefa tarefa) async {
    final db = await database;
    return db.insert('tarefas', tarefa.toMap());
  }

  Future<int> update(Tarefa tarefa) async {
    final db = await database;
    return db.update(
      'tarefas',
      tarefa.toMap(),
      where: 'id = ?',
      whereArgs: [tarefa.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await database;
    return db.delete(
      'tarefas',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
