import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
// ignore: depend_on_referenced_packages //
import 'package:meta/meta.dart';
import '../models/task.dart';

class DatabaseTaskHelper {
  static const _databaseName = "task_database.db";
  static const _databaseVersion = 1;

  static const table = 'tasks';

  static const columnId = 'id';
  static const columnTitle = 'title';
  static const columnDescription = 'description';
  static const columnStatus = 'status';
  static const columnCreatedAt = 'created_at';
  static const columnCompletedAt = 'completed_at';

  // Singleton pattern
  DatabaseTaskHelper._privateConstructor();
  static final DatabaseTaskHelper instance =
      DatabaseTaskHelper._privateConstructor();

  static Database? _database;

  // For testing purposes
  @visibleForTesting
  static void setDatabase(Database? database) {
    _database = database;
  }

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnTitle TEXT NOT NULL,
        $columnDescription TEXT NOT NULL,
        $columnStatus TEXT NOT NULL,
        $columnCreatedAt TEXT NOT NULL,
        $columnCompletedAt TEXT
      )
    ''');
  }

  Future<int> insert(TaskDto task) async {
    Database db = await database;
    return await db.insert(
      table,
      task.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<TaskDto>> getAllTasks() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(table);
    return List.generate(maps.length, (i) => TaskDto.fromJson(maps[i]));
  }

  Future<int> update(TaskDto task) async {
    Database db = await database;
    return await db.update(
      table,
      task.toJson(),
      where: '$columnId = ?',
      whereArgs: [task.id],
    );
  }

  Future<int> delete(int id) async {
    Database db = await database;
    return await db.delete(
      table,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }
}
