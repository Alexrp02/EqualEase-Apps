import 'package:flutter/material.dart';
import 'models/task.dart';
import 'models/subtask.dart';
import 'controllers/controller_api.dart';
import 'addSubtask.dart';

class EditTaskPage extends StatefulWidget {
  final Task task;

  EditTaskPage({required this.task});

  @override
  _EditTaskPageState createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  late String _editedTitle;
  late String _editedDescription;
  late List<Subtask> _editedSubtasks;
  late String _editedType;
  final controller = APIController();

  @override
  void initState() {
    super.initState();
    _editedTitle = widget.task.title;
    _editedDescription = widget.task.description;
    _editedSubtasks = [];

    controller.getSubtasksFromTaskList(widget.task.id).then((value) {
      setState(() {
        _editedSubtasks = value;
      });
    });

    _editedType = widget.task.type;
  }

  void _addSubtask(String subTask) {
    /*final newSubtask = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CrearSubtaskForm(onSubtaskSaved: _id),
      ),
    );
    if (newSubtask != null) {
      setState(() {
        _editedSubtasks.add(newSubtask);
      });
    }*/
  }

  void _deleteSubtask(Subtask subtask) {
    setState(() {
      _editedSubtasks.remove(subtask);
      controller.removeSubtaskFromTaskList(widget.task.id, subtask.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    int subtaskCount = 1; // Contador de subtareas
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
                  'EDITAR TAREA',
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                style: TextStyle(color: Colors.black, fontSize: 18),
                initialValue: _editedTitle.toUpperCase(),
                onChanged: (value) {
                  setState(() {
                    _editedTitle = value.toUpperCase();
                  });
                },
                decoration: InputDecoration(
                  labelText: 'TITULO',
                  labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                style: TextStyle(color: Colors.black, fontSize: 18),
                initialValue: _editedDescription,
                onChanged: (value) {
                  setState(() {
                    _editedDescription = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'DESCRIPCION',
                  labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 30),
              Text('SUBTAREAS:',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold)),
              Column(
                children: _editedSubtasks.map(
                  (subtask) {
                    return Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text('SUBTAREA ${subtaskCount++}',
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.black)),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              iconSize: 50.0,
                              onPressed: () {
                                _deleteSubtask(subtask);
                                widget.task.subtasks.remove(subtask.id);

                                controller.deleteSubtask(subtask.id);
                              },
                            ),
                          ],
                        ),
                        TextFormField(
                          style: TextStyle(color: Colors.black, fontSize: 18),
                          initialValue: subtask.title,
                          onChanged: (value) {
                            setState(() {
                              subtask.title = value;
                            });
                          },
                          decoration: InputDecoration(
                            labelText: 'TITULO SUBTAREA',
                            labelStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 25,
                                fontWeight: FontWeight.bold),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          style: TextStyle(color: Colors.black, fontSize: 18),
                          initialValue: subtask.description,
                          onChanged: (value) {
                            setState(() {
                              subtask.description = value;
                            });
                          },
                          decoration: InputDecoration(
                            labelText: 'DESCRIPCION SUBTAREA',
                            labelStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 25,
                                fontWeight: FontWeight.bold),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 16),
                      ],
                    );
                  },
                ).toList(),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CrearSubtaskForm(
                          //onSubtaskSaved: _addSubTask,
                          ),
                    ),
                  ).then((value) {
                    //_editedSubtasks.add(value);
                    //controller.addSubtaskToTaskList(widget.task.id, value);
                    widget.task.subtasks.add(value.id);
                    setState(() {
                      _editedSubtasks.add(value); //print(subTasks);
                    });
                  });
                },
                child: Text('AÑADIR SUBTAREA',
                    style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 161, 182, 236),
                  onPrimary: Colors.white,
                ),
              ),
              SizedBox(height: 30),
              DropdownButtonFormField<String>(
                value: _editedType,
                decoration: InputDecoration(
                  labelText: 'TIPO',
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                  border: OutlineInputBorder(),
                ),
                items: ['FixedType', 'RequestType'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value == 'RequestType' ? 'DEMANDA' : 'FIJA',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _editedType = newValue ??
                        ''; // Asegúrate de manejar el caso en el que newValue sea nulo
                  });
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  // Lógica para guardar los cambios realizados
                  widget.task.title = _editedTitle;
                  widget.task.description = _editedDescription;
                  // Actualizar las subtareas aquí
                  for (int i = 0; i < _editedSubtasks.length; i++) {
                    await controller.updateSubtask(_editedSubtasks[i]);
                  }
                  widget.task.type = _editedType;
                  // Llamar al controlador para guardar los cambios de la tarea
                  controller.updateTask(widget.task).then((value) {
                    //widget.task.title = value;
                    Navigator.pop(context, widget.task.title);
                  });
                },
                child: Text('GUARDAR CAMBIOS',
                    style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 161, 182, 236),
                  onPrimary: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
