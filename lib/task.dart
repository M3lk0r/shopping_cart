import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class Task {
  int? id;
  late String texto;
  bool done = false;
  File? image;

  Task({required this.texto, this.done = false});

  Future<File> _getLocalFile() async {
    final directory = await getApplicationDocumentsDirectory();
    String _localPath = directory.path;
    return File('$_localPath/taskList.json');
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'id': this.id,
      'texto': this.texto,
      'done': this.done,
      'imagePath': this.image != null ? this.image!.path : ''
    };
    return map;
  }

  Task.fromMap(Map map) {
    this.id = map['id'];
    this.texto = map['texto'];
    this.done = map['done'] == 1 ? true : false;
    this.image = map['imagePath'] != '' ? File(map['imagePath']) : null;
  }

  Future saveData(List<Task> tasks) async {
    final localFile = await _getLocalFile();
    List taskList = [];
    tasks.forEach((Task) {
      taskList.add(Task.toMap());
    });
    String data = json.encode(taskList);
    return localFile.writeAsStringSync(data);
  }

  Future<List<Task>?> getData() async {
    try {
      final localFile = await _getLocalFile();
      List taskList = [];
      List<Task> tasks = [];

      String content = await localFile.readAsString();
      taskList = json.decode(content);

      taskList.forEach((Task) {
        tasks.add(Task.fromMap(Task));
      });

      return tasks;
    } catch (error) {
      print(error);
      return null;
    }
  }
}
