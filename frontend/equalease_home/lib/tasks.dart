import 'package:flutter/material.dart';
import 'addTask.dart';
import 'models/task.dart'; // Importa la clase Task
import 'models/subtask.dart';
import 'controllers/controllerSubstask.dart';
import 'controllers/controllerTask.dart';
// import 'components/subtasks_widget.dart'; // Comenta la importación del carrusel de fotos

class TasksPage extends StatefulWidget {
  @override
  _TasksPageState createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  bool isLoading = true;
  List<Task> _TasksAgregadas = [
    // Task(
    //     id: "prueba",
    //     title: "Tarea de prueba",
    //     description: "Esta es una tarea de prueba para probar el carrusel",
    //     subtasks: [
    //       Subtask(
    //           id: "Prueba",
    //           title: "Coger las sabanas",
    //           description: "Acercate al armario y coge las sabanas"),
    //       Subtask(
    //           id: "afad",
    //           title: "Extender las sábanas",
    //           description: "Extiende las sábanas en algún lado plano.")
    //     ],
    //     type: "FixedType")
  ]; // Cambiar la lista a una lista de Tasks

  @override
  void initState() {
    super.initState();
    getAllTasks().then((value) {
      setState(() {
        _TasksAgregadas = value;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0),
        child: AppBar(
          backgroundColor: Color.fromARGB(255, 55, 55, 56),
          title: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'LISTA DE TAREAS',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 70.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: isLoading
          ? const Center(
              child: SizedBox(
                  width: 100, height: 100, child: CircularProgressIndicator()),
            )
          : Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8, // Ancho del 80%
                child: ListView.builder(
                  itemCount: _TasksAgregadas.length,
                  itemBuilder: (context, i) {
                    final Task TaskAgregada = _TasksAgregadas[i];
                    int currentIndex = i + 1;
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DetallesTaskPage(task: TaskAgregada),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color.fromARGB(255, 170, 172, 174),
                            width: 3.0,
                          ),
                          color: Color.fromARGB(255, 255, 255, 255),
                          borderRadius: BorderRadius.circular(0),
                        ),
                        margin: EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'TAREA $currentIndex: ${TaskAgregada.title}',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontSize: 30.0, // Ajusta el tamaño del texto
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    iconSize: 50.0,
                                    icon: Icon(Icons.edit),
                                    onPressed: () {
                                      // Lógica para editar la tarea
                                    },
                                  ),
                                  IconButton(
                                    iconSize: 50.0,
                                    icon: Icon(Icons.delete),
                                    onPressed: () {
                                      // Lógica para eliminar la tarea
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                          tileColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: Color.fromARGB(255, 170, 172, 174),
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(0),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
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
  // final Subtask subtask = new Subtask(
  //     id: "prueba",
  //     title: "Coger sábanas",
  //     description:
  //         "Acércate al armario donde se guardan las sábanas y cógelas.");

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
            Text('Título: ${task.title}',
                style: TextStyle(fontSize: 20.0)), // Ajusta el tamaño del texto
            Text('Descripción: ${task.description}',
                style: TextStyle(fontSize: 20.0)), // Ajusta el tamaño del texto
            Text(
              'SubTasks:${task.subtasks.toString()}',
              style: TextStyle(fontSize: 20.0), // Ajusta el tamaño del texto
            ),
            // for (var subTask in task.subtasks) Text(subTask.description),
            Text('Tipo: ${task.type}',
                style: TextStyle(fontSize: 20.0)), // Ajusta el tamaño del texto
          ],
        ),
      ),
    );
  }
}
