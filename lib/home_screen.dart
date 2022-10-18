import 'cadastro_screen.dart';
import 'task.dart';
import 'package:flutter/material.dart';
import 'package:carrinhocompras/task.dart';
import 'task_helper.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Task> _tarefas = List.empty(growable: true);
  TaskHelper _helper = TaskHelper();
//  FilePersistence filePersistence = FilePersistence();
//
//  @override
//  void didChangeDependencies() {
//    super.didChangeDependencies();
//    filePersistence.getiData().then((value) {
//      setState(() {
//        if (value != null) _tarefas = value;
//      });
//    });
//  }

  @override
  void initState() {
    super.initState();

    _helper.getAll().then((data) {
      setState(() {
        if (data != null) _tarefas = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Aula Listas"),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Container(
        child: ListView.separated(
          itemCount: _tarefas.length,
          separatorBuilder: (context, position) => Divider(),
          itemBuilder: (context, position) {
            Task _item = _tarefas[position];
            return Dismissible(
              key: Key(_item.texto),
              secondaryBackground: Container(
                color: Colors.red,
                child: const Align(
                    alignment: Alignment(0.9, 0.0),
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    )),
              ),
              background: Container(
                color: Colors.orange,
                child: const Align(
                    alignment: Alignment(-0.9, 0.0),
                    child: Icon(
                      Icons.edit,
                      color: Colors.white,
                    )),
              ),
              onDismissed: (direction) async {
                if (direction == DismissDirection.endToStart) {
                  var result = await _helper.deleteTask(_item);
                  setState(() {
                    _tarefas.removeAt(position);
                    //filePersistence.saveData(_tarefas);
                  });
                }
              },
              confirmDismiss: (direction) async {
                if (direction == DismissDirection.startToEnd) {
                  Task editedTask = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CadastroScreen(task: _item)));

                  var result = await _helper.editTask(editedTask);
                  if (editedTask != null) {
                    setState(() {
                      _tarefas.removeAt(position);
                      _tarefas.insert(position, editedTask);
                      //filePersistence.saveData(_tarefas);
                    });
                  }
                  return false;
                } else {
                  return true;
                }
              },
              child: ListTile(
                title: Text(
                  _item.texto,
                  style: _item.done
                      ? const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough)
                      : const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w400),
                ),
                onTap: () {
                  setState(() {
                    _item.done = !_item.done;
                  });
                },
                onLongPress: () async {
                  Task? editedTask = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CadastroScreen(task: _item)));
                  if (editedTask != null) {
                    setState(() {
                      _tarefas.removeAt(position);
                      _tarefas.insert(position, editedTask);
                    });
                  }
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () async {
          try {
            Task newTask = await Navigator.push(context,
                MaterialPageRoute(builder: (context) => CadastroScreen()));

            Task? savedTask = await _helper.saveTask(newTask);
            if (newTask != null) {
              setState(() {
                _tarefas.add(newTask);
                //filePersistence.saveData(_tarefas);
              });
            }
          } catch (error) {
            print("Error: ${error.toString()}");
          }
        },
      ),
    );
  }
}
