import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'tarefas.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE tarefas (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            titulo TEXT NOT NULL,
            concluida INTEGER NOT NULL DEFAULT 0
          )
        ''');
      },
    );
  }

  Future<int> inserirTarefa(String titulo) async {
    final db = await database;

    return await db.insert(
      'tarefas',
      {
        'titulo': titulo,
        'concluida': 0,
      },
    );
  }

  Future<List<Map<String, dynamic>>> listarTarefas() async {
    final db = await database;

    return await db.query(
      'tarefas',
      orderBy: 'id DESC',
    );
  }

  Future<int> atualizarTarefa(
    int id,
    String titulo,
    bool concluida,
  ) async {
    final db = await database;

    return await db.update(
      'tarefas',
      {
        'titulo': titulo,
        'concluida': concluida ? 1 : 0,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deletarTarefa(int id) async {
    final db = await database;

    return await db.delete(
      'tarefas',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Exercício 02:
  // Exclui todas as tarefas do banco de dados.
  Future<int> deleteAll() async {
    final db = await database;

    return await db.delete('tarefas');
  }

  // Exercício 03:
  // Busca tarefas pelo título usando LIKE.
  Future<List<Map<String, dynamic>>> buscarTarefas(
    String texto,
  ) async {
    final db = await database;

    return await db.query(
      'tarefas',
      where: 'titulo LIKE ?',
      whereArgs: ['%$texto%'],
      orderBy: 'id DESC',
    );
  }

  // Exercício 01:
  // Retorna a quantidade total de tarefas.
  Future<int> contarTarefas() async {
    final db = await database;

    final resultado = await db.rawQuery(
      'SELECT COUNT(*) as total FROM tarefas',
    );

    return Sqflite.firstIntValue(resultado) ?? 0;
  }
}
