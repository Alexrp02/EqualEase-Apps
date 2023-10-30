import 'package:flutter/material.dart';
import 'addTask.dart';

class TasksPage extends StatefulWidget {
  @override
  _TareasPageState createState() => _TareasPageState();
}

class _TareasPageState extends State<TasksPage> {
  List<String> _tareas = [
    'Tarea 1',
    'Tarea 2',
    'Tarea 3',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Tareas'),
      ),
      body: ListView.builder(
        itemCount: _tareas.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_tareas[index]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AgregarTareaPage(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
