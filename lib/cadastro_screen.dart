import 'package:carrinhocompras/task_helper.dart';

import 'Task.dart';
import 'package:flutter/material.dart';

class CadastroScreen extends StatefulWidget {
  Task? task;

  CadastroScreen({this.task});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  TextEditingController _textController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TaskHelper _helper = TaskHelper();

  @override
  void initState() {
    super.initState();

    _helper.getAll().then((data) {
      setState(() {
        if (data != null) _lista = data;
      });
    });

    if (widget.task != null) {
      setState(() {
        _textController.text = widget.task!.texto;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cadastro Listas"),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: TextFormField(
                controller: _textController,
                style: const TextStyle(fontSize: 18),
                decoration: const InputDecoration(
                  label: Text("task"),
                  labelStyle: TextStyle(fontSize: 18),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Preenchimento obrigatório";
                  }
                },
              ),
            ),
            Row(children: [
              Expanded(
                child: Container(
                  height: 65,
                  padding: EdgeInsets.all(10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary:
                            widget.task == null ? Colors.green : Colors.orange),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Task task = Task(texto: _textController.text);
                        Navigator.pop(context, task);
                      }
                    },
                    child: widget.task == null
                        ? const Text("Cadastrar")
                        : const Text("Editar"),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 65,
                  padding: EdgeInsets.all(10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.red),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Cancelar"),
                  ),
                ),
              )
            ])
          ],
        ),
      ),
    );
  }
}
