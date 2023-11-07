import 'package:flutter/material.dart';
import 'addSubtask.dart';
import 'models/task.dart'; // Importar la clase Task
import 'models/subtask.dart';
import 'controllers/controllerTask.dart'; // Importar el controlador

class AgregarTaskPage extends StatefulWidget {
  final Function(Task) onTaskSaved; // Ajusta el tipo de parámetro

  AgregarTaskPage({required this.onTaskSaved});

  @override
  _AgregarTaskPageState createState() => _AgregarTaskPageState();
}

class _AgregarTaskPageState extends State<AgregarTaskPage> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _descripcionController = TextEditingController();
  List<String> subTasks = [];
  int contador = 1;
  String? _tipoSeleccionado;
  final List<String> _opcionesTipo = ['Fija', 'Demanda']; // Opciones de tipo

  @override
  void dispose() {
    _tituloController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  void _addSubTask(String subTask) {
    setState(() {
      String nuevaSubtarea = "test";
      subTasks.add(nuevaSubtarea);
      contador++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _tituloController,
                decoration: InputDecoration(
                  labelText: 'Título',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un título';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descripcionController,
                decoration: InputDecoration(
                  labelText: 'Descripción',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese una descripción';
                  }
                  return null;
                },
              ),
              Text(
                'SubTasks:',
              ),
              // for (var subTask in subTasks) Text(subTask.description),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CrearSubtaskForm(
                        onSubtaskSaved: _addSubTask,
                      ),
                    ),
                  ).then((value) {
                    subTasks.add(value);
                    print(subTasks);
                  });
                },
                child: Text('Añadir SubTask'),
              ),
              DropdownButtonFormField<String>(
                value: _tipoSeleccionado,
                decoration: InputDecoration(labelText: 'Tipo'),
                items: _opcionesTipo.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _tipoSeleccionado = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty || value == 'Tipo') {
                    return 'Por favor seleccione un tipo';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Task nuevaTask = Task(
                      id: 'a',
                      title: _tituloController.text,
                      description: _descripcionController.text,
                      subtasks: subTasks,
                      type: _tipoSeleccionado!,
                    );

                    createTask(
                        nuevaTask); // Llamar a la función onTaskSaved con la nueva Task
                    Navigator.pop(context);
                  }
                },
                child: Text('Guardar Task'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Task nuevaTask = Task(
                      id: 'a',
                      title: _tituloController.text,
                      description: _descripcionController.text,
                      subtasks: subTasks,
                      type: _tipoSeleccionado!,
                    );

                    print(nuevaTask.toJson());
                  }
                },
                child: Text('Mostrar Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
