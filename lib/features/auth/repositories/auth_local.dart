import 'package:milo/core/services/sp_service.dart';
import 'package:milo/features/auth/repositories/task_local.dart';
import 'package:milo/models/user_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AuthLocal {
  String tableName = "users";
  final sp = SpService();

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
    final path = join(dbPath, "auth.db");
    return openDatabase(path, version: 1, onCreate: (db, version) {
      return db.execute("""CREATE TABLE $tableName(
            id TEXT PRIMARY KEY,
            email TEXT NOT NULL,
            token TEXT NOT NULL,
            name TEXT NOT NULL,
            createdAt INT NOT NULL,
            updatedAt INT NOT NULL,
            age INT
          )""");
    });
  }

  Future<void> insertUser(UserModel user) async {
    final db = await database;
    await db.insert(tableName, user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<UserModel?> getUser() async {
    final db = await database;
    final result = await db.query(tableName, limit: 1);
    if (result.isEmpty) return null;
    return UserModel.fromMap(result.first);
  }

  Future<void> deleteUser() async {
    final db = await database;
    await db.delete(tableName);
    final taskLocal = TaskLocal();
    taskLocal.deleteTasks();
    sp.removeToken();
  }
}
