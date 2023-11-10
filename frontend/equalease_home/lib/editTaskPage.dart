import 'package:flutter/material.dart';
import 'models/task.dart';
import 'models/subtask.dart';
import 'controllers/controller_api.dart';

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

    setState(() {
      controller.getSubtasksFromTaskList(widget.task.id).then((value) {
        _editedSubtasks = value;
      });
    });
  
    _editedType = widget.task.type;
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
                initialValue: _editedTitle,
                onChanged: (value) {
                  setState(() {
                    _editedTitle = value;
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
                children: _editedSubtasks.asMap().entries.map(
                  (entry) {
                    int index = entry.key;
                    Subtask subtask = entry.value;
                    return Column(
                      children: [
                        Text('SUBTAREA ${subtaskCount++}',
                            style:
                                TextStyle(fontSize: 20, color: Colors.black)),
                        TextFormField(
                          style: TextStyle(color: Colors.black, fontSize: 18),
                          initialValue: subtask.title,
                          onChanged: (value) {
                            setState(() {
                              _editedSubtasks[index].title = value;
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
                              _editedSubtasks[index].description = value;
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
              TextFormField(
                style: TextStyle(color: Colors.black, fontSize: 18),
                initialValue: _editedType,
                onChanged: (value) {
                  setState(() {
                    _editedType = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'TIPO',
                  labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Lógica para guardar los cambios realizados
                  widget.task.title = _editedTitle;
                  widget.task.description = _editedDescription;
                  //widget.task.subtasks = _editedSubtasks; LLAMAR AQUI AL METODO PARA ACTUALIZAR SUBTAREA
                  widget.task.type = _editedType;
                  // Aquí se pueden llamar a los controladores para guardar los cambios
                  Navigator.pop(context);
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
