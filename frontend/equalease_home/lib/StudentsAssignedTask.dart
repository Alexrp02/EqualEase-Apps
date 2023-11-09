import 'package:equalease_home/controllers/controllerStudent.dart';
import 'package:equalease_home/models/student.dart';
import 'package:equalease_home/models/task.dart';
import 'package:flutter/material.dart';
import 'package:equalease_home/models/task.dart';

class StudentsAssignedTask extends StatefulWidget {
  final String _id;

  StudentsAssignedTask(String studentId) : _id = studentId;

  @override
  _StudentsAssignedTaskState createState() => _StudentsAssignedTaskState();
}

class _StudentsAssignedTaskState extends State<StudentsAssignedTask> {
  final ControllerStudent _controller = ControllerStudent('http://10.0.2.2:3000/api');
  Student? _student;
  List<Task> _pendingTasks= [];
  List<Task> selectedTasks = []; // Lista para almacenar tareas seleccionadas
  List<Task> totalTasks = []; // Lista para almacenar todas las tareas

  _StudentsAssignedTaskState() {
    // Inicializar totalTasks en el constructor
    Task tarea1 = Task(
      id: '1',
      title: 'Tarea 1',
      description: 'Descripción de la tarea 1',
      subtasks: [],
      type: 'FixedType',
    );
    totalTasks.add(tarea1);
  }

  void _openTaskSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Seleccionar Tareas"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              for (Task task in totalTasks)
                CheckboxListTile(
                  title: Text(task.title),
                  value: selectedTasks.contains(task),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value != null) {
                        if (value) {
                          selectedTasks.add(task);
                        } else {
                          selectedTasks.remove(task);
                        }
                      }
                    });
                  },
                ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Aceptar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _controller.getStudent(widget._id).then((student) {
      setState(() {
        _student = student;
        _controller.getPendingTasksFromStudent(widget._id).then((tasks){
          setState((){
            for (Task task in tasks){
              _pendingTasks.add(task);
            }
          });
            
        });
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
                  'TAREAS ASIGNADAS',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: _student == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: Column(
                children: <Widget>[
                  Text('NOMBRE DEL ALUMNO'),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color.fromARGB(255, 170, 172, 174),
                          width: 3.0,
                        ),
                      ),
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            for (int i = 0; i < selectedTasks.length; i++)
                              Container(
                                padding: EdgeInsets.all(0),
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  border: Border.all(
                                    color: const Color.fromARGB(255, 170, 172, 174),
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(0),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Text(selectedTasks[i].title),
                                    Container(
                                      width: 200,
                                      height: 50,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          // TODO
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          padding: EdgeInsets.all(0),
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                              color: Color.fromARGB(255, 100, 100, 101),
                                              width: 2.0,
                                            ),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                        child: Text('Borrar'),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _openTaskSelectionDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
