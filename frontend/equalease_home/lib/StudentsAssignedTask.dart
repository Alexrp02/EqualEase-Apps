import 'package:equalease_home/controllers/controllerStudent.dart';
import 'package:equalease_home/models/student.dart';
import 'package:equalease_home/models/task.dart';
import 'package:flutter/material.dart';

class StudentsAssignedTask extends StatefulWidget {
  final String _id;

  StudentsAssignedTask(String id) : _id = id;

  @override
  _StudentsAssignedTaskState createState() => _StudentsAssignedTaskState();
}

class _StudentsAssignedTaskState extends State<StudentsAssignedTask> {
  final ControllerStudent _controller = ControllerStudent('http://10.0.2.2:3000/api');
  Student? _student;
  List<Task> _pendingTasks= [];

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
            backgroundColor: Color.fromARGB(255,161, 182, 236),
            title: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'TAREAS ASIGNADAS',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white, // Cambia el color de la fuente a blanco
                      fontWeight: FontWeight.bold, // Hace la fuente más gruesa
                      fontSize: 24.0, // Cambia el tamaño de la fuente
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
                Text(
                  _student!.name,
                  style: TextStyle(
                    fontSize: 40, 
                    fontWeight: FontWeight.bold
                  ),
                ),
                Expanded( // Utiliza un Expanded para que el SingleChildScrollView ocupe el espacio restante
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color.fromARGB(255, 170, 172, 174),
                        width: 3.0,
                      ),
                    ),
                    width: MediaQuery.of(context).size.width * 0.8,
                    // El height se establece a null para que el Container ocupe el espacio disponible
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          for (int i = 0; i < _pendingTasks.length; i++)
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
                                  Text(_pendingTasks[i].title),
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
    );
  }
}
