import 'package:flutter/material.dart';
import 'addTask.dart';
import 'task.dart'; // Importa la clase Tarea

class TasksPage extends StatefulWidget {
  @override
  _TareasPageState createState() => _TareasPageState();
}

class _TareasPageState extends State<TasksPage> {
  List<Tarea> _tareasAgregadas = []; // Cambiar la lista a una lista de Tareas

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Tareas'),
      ),
      body: ListView.builder(
        itemCount: _tareasAgregadas.length,
        itemBuilder: (context, i) {
          final Tarea tareaAgregada = _tareasAgregadas[i]; // Cambiar el tipo de la variable
          int currentIndex = i + 1; // Número de tarea actual
          return ListTile(
            title: Text('Tarea $currentIndex: ${tareaAgregada.titulo}'), // Mostrar el título de la tarea
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetallesTareaPage(tarea: tareaAgregada),
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
              builder: (context) => AgregarTareaPage(
                onTareaSaved: (tarea) { // Ajusta el parámetro para que sea de tipo Tarea
                  setState(() {
                    _tareasAgregadas.add(tarea);
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

class DetallesTareaPage extends StatelessWidget {
  final Tarea tarea;

  DetallesTareaPage({required this.tarea});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles de la Tarea'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Título: ${tarea.titulo}'),
            Text('Descripción: ${tarea.descripcion}'),
            Text('Subtareas: ${tarea.subtareas.join(", ")}'),
            Text('Tipo: ${tarea.tipo}'),
          ],
        ),
      ),
    );
  }
}
