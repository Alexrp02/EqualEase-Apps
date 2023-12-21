import 'dart:async';

import 'package:equalease_home/components/days_selector.dart';
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
          actions: [
            // Agrega el botón de cerrar sesión en el AppBar
            IconButton(
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              icon: Icon(
                Icons.exit_to_app,
                size: 70.0,
              ),
            ),
          ],
          backgroundColor: Color.fromARGB(255, 161, 182, 236),
          toolbarHeight: 100.0,
          leading: new IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: new Icon(
                Icons.arrow_back,
                size: 50.0,
              )),
          title: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _student != null
                    ? Text(
                        'TAREAS ASIGNADAS DE ${_student!.name.toUpperCase()}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 50.0,
                        ),
                      )
                    :
                    // Si no se ha obtenido el estudiante, se muestra un texto genérico
                    const Text(
                        'TAREAS',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 50.0,
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
                    _student!.name.toUpperCase(),
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
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
                            for (Map<String, dynamic> taskId
                                in _student!.pendingTasks)
                              Container(
                                padding: EdgeInsets.all(0),
                                // height: 80,
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  border: Border.all(
                                    color: const Color.fromARGB(
                                        255, 170, 172, 174),
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(0),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        totalTasks
                                            .firstWhere((task) =>
                                                task.id == taskId['id'])
                                            .title,
                                        style: const TextStyle(
                                          fontSize: 40,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 200,
                                      height: 50,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            _student!.pendingTasks.removeWhere(
                                                (task) =>
                                                    taskId['id'] == task['id']);
                                            _controller
                                                .updateStudent(_student!);
                                          });
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          padding: const EdgeInsets.all(0),
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
      floatingActionButton: SizedBox(
        width: 100,
        height: 100,
        child: FloatingActionButton(
            onPressed: () {
              _openTaskSelectionDialog(context);
            },
            backgroundColor: const Color.fromARGB(255, 161, 182, 236),
            child: const Icon(
              Icons.add,
              color: Colors.white,
              size: 50.0,
            )),
      ),
    );
  }
}

class CustomDialog extends StatefulWidget {
  final List<Map<String, dynamic>> pendingTasks;
  final List<Task> totalTasks;
  final Function(List<Map<String, dynamic>>) onTasksUpdated;
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
  List<String> selectedDays = [];

  Future<void> _selectDays(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Days'),
          content: Column(
            children: [
              for (String day in [
                'Lunes',
                'Martes',
                'Miercoles',
                'Jueves',
                'Viernes',
                'Sábado',
                'Domingo'
              ])
                Row(
                  children: [
                    Checkbox(
                        value: selectedDays.contains(day),
                        onChanged: (value) {
                          setState(() {
                            if (value != null) {
                              if (value) {
                                selectedDays.add(day);
                              } else {
                                selectedDays.remove(day);
                              }
                            }
                          });
                        }),
                    Text(day),
                  ],
                ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Seleccionar Tareas",
        style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            for (Task task in widget.totalTasks)
              CheckboxListTile(
                title: Text(
                  task.title,
                  style: const TextStyle(fontSize: 40.0),
                ),
                value: widget.student!.pendingTasks
                    .any((arrayTask) => task.id == arrayTask['id']),
                onChanged: (bool? value) async {
                  if (value == true) {
                    DateTimeRange? dateRange = await showDateRangePicker(
                        context: context,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2101),
                        helpText: "Seleccione el intervalo de tiempo",
                        fieldStartHintText: "Fecha de inicio",
                        fieldEndHintText: "Fecha de fin",
                        saveText: "Aceptar",
                        cancelText: "Cancelar",
                        fieldStartLabelText: "Inicio",
                        fieldEndLabelText: "Fin");

                    if (mounted) {
                      selectedDays = await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return DaysSelector();
                          });
                    }

                    setState(() {
                      if (value != null) {
                        if (value) {
                          widget.student!.pendingTasks.add({
                            'id': task.id,
                            'startDate': dateRange != null
                                ? "${dateRange.start.year}-${dateRange.start.month}-${dateRange.start.day}"
                                : "",
                            'endDate': dateRange != null
                                ? "${dateRange.end.year}-${dateRange.end.month}-${dateRange.end.day}"
                                : "",
                            'daysOfTheWeek': selectedDays
                          });
                        } else {
                          widget.student!.pendingTasks.remove(task.id);
                        }
                      }

                      widget.onTasksUpdated(widget.student!.pendingTasks);
                    });
                  }
                },
              ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text(
            "Aceptar",
            style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
