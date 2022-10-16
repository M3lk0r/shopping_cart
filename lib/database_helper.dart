import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'task_helper.dart';
import 'task.dart';

class DatabaseHelper {
  Database? _db;

  static final DatabaseHelper _instance = DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  DatabaseHelper.internal();

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }

  Future<Database?> initDb() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, taskDatabase.db);

    try {
      return _db = await openDatabase(path,
          version: 1, onCreate: _onCreateDB, onUpgrade: _onUpgradeDB);
    } catch (e) {
      print(e);
    }
  }

  Future _onCreateDB(Database db, int newVersion) async {
    await db.execute(TaskHelper.createScript);
  }

  Future _onUpgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      await db.execute("DROP TABLE ${TaskHelper.tableName};");
      await _onCreateDB(db, newVersion);
    }
  }
}
