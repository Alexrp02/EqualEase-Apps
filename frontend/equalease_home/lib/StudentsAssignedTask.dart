import 'package:equalease_home/controllers/controller_api.dart';
import 'package:equalease_home/models/student.dart';
import 'package:equalease_home/models/task.dart';
import 'package:flutter/material.dart';
   

class StudentsAssignedTask extends StatefulWidget {
  final String _id;

  StudentsAssignedTask(String studentId) : _id = studentId;

  @override
  _StudentsAssignedTaskState createState() => _StudentsAssignedTaskState();
}

class _StudentsAssignedTaskState extends State<StudentsAssignedTask> {
  final APIController _controller = APIController();
  Student? _student;

  //IMPORTANTE !!!!!!!!!!!!!!!!!!!!!!!!!!!
  //Preguntar al cliente si quiere que se puedan repetir las tareas asignadas. En caso contrario cambiar el list por un set
  List<Task> selectedTasks = []; // Lista para almacenar tareas seleccionadas
  List<Task> totalTasks = []; // Lista para almacenar todas las tareas

  _StudentsAssignedTaskState() {
    // IMPORTANTE !!!!!!!!!!!!!!!!!!!!!!!!!!!
    // Inicializar totalTasks y selectedTasks en el constructor con llamadas al controlador (actualmente solo es local)
    _controller.getTasks().then((tasks){
          setState((){
            for (Task task in tasks){
              totalTasks.add(task);
            }
          });
      }
    );
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
                          //llamar a la funcion del controlador assignTaskToStudent
                          selectedTasks.add(task);
                          _student!.pendingTasks.add(task.id);
                          _controller.updateStudent(_student!);
                        } else {
                          selectedTasks.remove(task);
                          _student!.pendingTasks.remove(task.id);
                          _controller.updateStudent(_student!);
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
              selectedTasks.add(task);
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
                  Text(
                  _student!.name,
                  style: TextStyle(
                    fontSize: 40, 
                    fontWeight: FontWeight.bold
                  ),
                ),
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
                                          setState(() {
                                      
                                            selectedTasks.remove(selectedTasks[i]); //Lo quitamos por ser local?

                                            _student!.pendingTasks.remove(_student!.pendingTasks[i]);

                                            _controller.updateStudent(_student!);
                                          });
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
                                        child: Text('Quitar'),
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
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor:  Color.fromARGB(255, 161, 182, 236)
      )
    );
  }
}
