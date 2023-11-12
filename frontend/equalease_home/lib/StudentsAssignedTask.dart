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
  List<Task> totalTasks = [];

  _StudentsAssignedTaskState() {
    _controller.getTasks().then((tasks) {
      setState(() {
        totalTasks.addAll(tasks);
      });
    });
  }

  void _openTaskSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialog(
          pendingTasks: _student!.pendingTasks,
          totalTasks: totalTasks,
          student: _student,
          onTasksUpdated: (updatedTasks) {
            setState(() {
              _student!.pendingTasks = updatedTasks;
              _controller.updateStudent(_student!);
            });
          },
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
                        fontSize: 40, fontWeight: FontWeight.bold),
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
                            for (String taskId in _student!.pendingTasks)
                              Container(
                                padding: EdgeInsets.all(0),
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  border: Border.all(
                                    color:
                                        const Color.fromARGB(255, 170, 172, 174),
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(0),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Text(
                                      totalTasks
                                          .firstWhere((task) => task.id == taskId)
                                          .title,
                                    ),
                                    Container(
                                      width: 200,
                                      height: 50,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            _student!.pendingTasks.remove(taskId);
                                            _controller.updateStudent(_student!);
                                          });
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          padding: EdgeInsets.all(0),
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                              color: Color.fromARGB(
                                                  255, 100, 100, 101),
                                              width: 2.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10),
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
          backgroundColor: Color.fromARGB(255, 161, 182, 236)),
    );
  }
}

class CustomDialog extends StatefulWidget {
  final List<String> pendingTasks;
  final List<Task> totalTasks;
  final Function(List<String>) onTasksUpdated;
  final Student? student;

  CustomDialog({
    required this.pendingTasks,
    required this.totalTasks,
    required this.onTasksUpdated,
    required this.student,
  });

  @override
  State<StatefulWidget> createState() {
    return _CustomDialogState();
  }
}

class _CustomDialogState extends State<CustomDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Seleccionar Tareas"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            for (Task task in widget.totalTasks)
              CheckboxListTile(
                title: Text(task.title),
                value: widget.student!.pendingTasks.contains(task.id),
                onChanged: (bool? value) {
                  setState(() {
                    if (value != null) {
                      if (value) {
                        widget.student!.pendingTasks.add(task.id);
                      } else {
                        widget.student!.pendingTasks.remove(task.id);
                      }
                    }

                    widget.onTasksUpdated(widget.student!.pendingTasks);
                  });
                },
              ),
          ],
        ),
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
  }
}
