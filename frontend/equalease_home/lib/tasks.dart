import 'package:flutter/material.dart';
import 'addTask.dart';
import 'models/task.dart'; // Importa la clase Task
import 'models/subtask.dart';
import 'controllers/controllerSubstask.dart';

class TasksPage extends StatefulWidget {
  @override
  _TasksPageState createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  List<Task> _TasksAgregadas = []; // Cambiar la lista a una lista de Tasks

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Tasks'),
      ),
      body: ListView.builder(
        itemCount: _TasksAgregadas.length,
        itemBuilder: (context, i) {
          final Task TaskAgregada =
              _TasksAgregadas[i]; // Cambiar el tipo de la variable
          int currentIndex = i + 1; // Número de Task actual
          return ListTile(
            title: Text(
                'Task $currentIndex: ${TaskAgregada.title}'), // Mostrar el título de la Task
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetallesTaskPage(task: TaskAgregada),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AgregarTaskPage(
                onTaskSaved: (Task) {
                  // Ajusta el parámetro para que sea de tipo Task
                  setState(() {
                    _TasksAgregadas.add(Task);
                  });
                },
              ),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class DetallesTaskPage extends StatelessWidget {
  final Task task;

  DetallesTaskPage({required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles de la Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Título: ${task.title}'),
            Text('Descripción: ${task.description}'),
            FutureBuilder<List<Subtask>>(
              future: getAllSubtasks(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('SubTasks:'),
                      for (var subtarea in snapshot.data!) Text(subtarea.title),
                    ],
                  );
                } else {
                  return Text('No se pudieron obtener las subtareas.');
                }
              },
            ),
            Text('Tipo: ${task.type}'),
          ],
        ),
      ),
    );
  }
}
