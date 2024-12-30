import 'package:milo/models/task_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class TaskLocal {
  String tableName = "tasks";

  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, "tasks.db");
    // databaseFactory.deleteDatabase(path);
    return openDatabase(path, version: 4, onCreate: (db, version) {
      return db.execute("""CREATE TABLE $tableName(
            id TEXT PRIMARY KEY,
            uid TEXT NOT NULL,
            title TEXT NOT NULL,
            description TEXT NOT NULL,
            hexColor TEXT NOT NULL,
            deadline INT NOT NULL,
            createdAt INT NOT NULL,
            updatedAt INT NOT NULL,
            isSynced INT NOT NULL
          )""");
    });
  }

  Future<void> insertTasks(List<TaskModel> tasks) async {
    final db = await database;
    final batch = db.batch();
    for (final task in tasks) {
      batch.insert(tableName, task.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }

  Future<void> insertTask(TaskModel task) async {
    final db = await database;
    await db.insert(tableName, task.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<TaskModel>> getTasks() async {
    final db = await database;
    final result = await db.query(tableName);
    if (result.isEmpty) return [];
    List<TaskModel> taskModels = [];
    for (final elem in result) {
      taskModels.add(TaskModel.fromMap(elem));
    }
    return taskModels;
  }

  Future<void> deleteTasks() async {
    final db = await database;
    await db.delete(tableName);
  }

  Future<List<TaskModel>> getUnsyncedTasks() async {
    final db = await database;
    final result = await db.query(
      tableName,
      where: "isSynced = ?",
      whereArgs: [0],
    );
    if (result.isNotEmpty) {
      List<TaskModel> tasks = [];
      for (final elem in result) {
        tasks.add(TaskModel.fromMap(elem));
      }
      return tasks;
    }
    return [];
  }

  Future<void> updateRowValue(String id, int newValue) async {
    final db = await database;
    await db.update(tableName, {'isSynced': newValue},
        where: 'id = ?', whereArgs: [id]);
  }
}
