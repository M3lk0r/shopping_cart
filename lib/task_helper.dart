import 'package:sqflite/sqflite.dart';
import 'task.dart';
import 'database_helper.dart';

class TaskHelper {
  static final String tableName = 'tasks';
  static final String idColumn = 'id';
  static final String textColumn = 'texto';
  static final String doneColumn = 'done';
  static final String imagePathColumn = 'imagePath';

  static String get createScript {
    return "CREATE TABLE ${tableName}($idColumn INTEGER PRIMARY KEY AUTOINCREMENT," +
        "$textColumn TEXT NOT NULL, $doneColumn INTEGER NOT NULL, $imagePathColumn STRING);";
  }

  Future<Task?> saveTask(Task task) async {
    Database? db = await DatabaseHelper().db;
    if (db != null) {
      task.id = await db.insert(tableName, Task.toMap());
      return task;
    }
    return null;
  }

  Future<List<Task>?> getAll() async {
    Database? db = await DatabaseHelper().db;
    if (db == null) return null;

    List<Map> returnedTasks = await db.query(tableName,
        columns: [idColumn, textColumn, doneColumn, imagePathColumn]);

    List<Task> tasks = List.empty(growable: true);

    for (Map task in returnedTasks) {
      tasks.add(Task.fromMap(task));
    }

    return tasks;
  }

  Future<Task?> getById(int id) async {
    Database? db = await DatabaseHelper().db;
    if (db == null) return null;

    List<Map> returnedTask = await db.query(tableName,
        columns: [idColumn, textColumn, doneColumn, imagePathColumn],
        where: "$idColumn = ?",
        whereArgs: [id]);

    return Task.fromMap(returnedTask.first);
  }

  Future<int?> editTask(Task task) async {
    Database? db = await DatabaseHelper().db;
    if (db == null) return null;

    return await db.update(tableName, task.toMap(),
        where: "$idColumn = ?", whereArgs: [task.id]);
  }

  Future<int?> deleteTask(Task task) async {
    Database? db = await DatabaseHelper().db;
    if (db == null) return null;

    return await db
        .delete(tableName, where: "$idColumn = ?", whereArgs: [task.id]);
  }
}
