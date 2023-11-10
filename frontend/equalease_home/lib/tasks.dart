import 'package:equalease_home/editTaskPage.dart';
import 'package:flutter/material.dart';
import 'addTask.dart';
import 'models/task.dart'; // Importa la clase Task
import 'models/subtask.dart';
import 'controllers/controller_api.dart';
//import 'controllers/controllerSubstask.dart';
//import 'controllers/controllerTask.dart';
// import 'components/subtasks_widget.dart'; // Comenta la importación del carrusel de fotos
import 'editTaskPage.dart';
import 'controllers/controller_api.dart';

class TasksPage extends StatefulWidget {
  @override
  _TasksPageState createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  bool isLoading = true;
  final controller = APIController();

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

    controller.getTasks().then((value) {
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
          backgroundColor: Color.fromARGB(255, 161, 182, 236),
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
                            builder: (context) => DetallesTaskPage(
                              task: TaskAgregada,
                              controller: controller,
                            ),
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
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              EditTaskPage(task: TaskAgregada),
                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    iconSize: 50.0,
                                    icon: Icon(Icons.delete),
                                    onPressed: () {
                                      _showDeleteConfirmationDialog(
                                          TaskAgregada);
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
                onTaskSaved: (task) {
                  // Ajusta el parámetro para que sea de tipo Task
                },
              ),
            ),
          ).then((value) {
            setState(() {
              _TasksAgregadas.add(value);
            });
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showDeleteConfirmationDialog(Task task) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "ELIMINAR TAREA",
            style: TextStyle(
              color: Color.fromARGB(255, 0, 0, 0),
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Text(
                  "¿ESTA SEGURO?",
                  style: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontSize: 20.0,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text(
                "CANCELAR",
                style: TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 20.0,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                "ACEPTAR",
                style: TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                for (var i = 0; i < task.subtasks.length; i++) {
                  controller.deleteSubtask(task.subtasks[i]);
                }
                controller.deleteTask(task.id);
                setState(() {
                  _TasksAgregadas.remove(task);

                  // Llamar al controlador de eliminación
                });
                Navigator.of(context).pop();
              },
            ),
          ],
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
        );
      },
    );
  }
}

class DetallesTaskPage extends StatelessWidget {
  final Task task;
  final APIController controller;

  DetallesTaskPage({required this.task, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0),
        child: AppBar(
          backgroundColor: Color.fromARGB(255, 161, 182, 236),
          title: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'DETALLES DE LA TAREA',
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
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('TITULO: ',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
                Text('${task.title}',
                    style: TextStyle(
                      fontSize: 22.0,
                      color: Colors.black,
                    )),
                SizedBox(height: 30),
                Text('DESCRIPCION: ',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
                Text('${task.description}',
                    style: TextStyle(
                      fontSize: 22.0,
                      color: Colors.black,
                    )),
                SizedBox(height: 30),
                Text('SUBTAREAS: ',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
                FutureBuilder<List<Subtask>>(
                  future: controller.getSubtasksFromTaskList(task.id),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(snapshot.data!.length, (index) {
                          final subtask = snapshot.data![index];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('SUBTAREA ${index + 1}:',
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold)),
                              Text('TITULO: ${subtask.title}',
                                  style: TextStyle(fontSize: 22)),
                              Text('DESCRIPCION: ${subtask.description}',
                                  style: TextStyle(
                                      fontSize: 22, color: Colors.black)),
                              SizedBox(height: 30),
                            ],
                          );
                        }),
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error al cargar las subtareas');
                    }
                    return CircularProgressIndicator();
                  },
                ),
                SizedBox(height: 30),
                Text('TIPO: ',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
                Text(
                  '${task.type == "RequestType" ? "DEMANDA" : "FIJA"}',
                  style: TextStyle(
                    fontSize: 22.0,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
