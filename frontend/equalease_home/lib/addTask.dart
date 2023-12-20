import 'package:flutter/material.dart';
import 'addSubtask.dart';
import 'models/task.dart'; // Importar la clase Task
import 'models/subtask.dart';
//import 'controllers/controllerTask.dart'; // Importar el controlador
import 'controllers/controller_api.dart';

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
  List<Subtask> _editedSubtasks = [];
  List<String> subTasks = [];
  int contador = 1;
  String? _tipoSeleccionado;
  final List<String> _opcionesTipo = ['FIJA', 'DEMANDA']; // Opciones de tipo
  final controller = APIController();

  @override
  void dispose() {
    _tituloController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  void _addSubTask(String subTask) {
    // setState(() {
    //   Subtask nuevaSubtarea = Subtask(
    //       id: contador.toString(),
    //       title: 'SUBTAREA $contador',
    //       description: "PRUEBA",
    //       image: '',
    //       pictogram: '',
    //       audio: ' ',
    //       video: ' ');
    //   subTasks.add(nuevaSubtarea);
    //   contador++;
    // });
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
                  'NUEVA TAREA',
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _tituloController,
                decoration: InputDecoration(
                  labelText: 'TITULO',
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25.0,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'POR FAVOR INGRESE UN TITULO';
                  }
                  return null;
                },
              ),
              SizedBox(
                  height: 30), // Agrega un espacio adicional entre los campos
              TextFormField(
                controller: _descripcionController,
                decoration: InputDecoration(
                  labelText: 'DESCRIPCION',
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25.0,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'POR FAVOR INGRESE UNA DESCRIPCION';
                  }
                  return null;
                },
              ),
              SizedBox(
                  height: 30), // Agrega un espacio adicional entre los campos
              SizedBox(height: 30),
              Text('SUBTAREAS:',
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.black,
                      fontWeight: FontWeight.bold)),
              Column(
                children: _editedSubtasks.map(
                  (subtask) {
                    return Column(
                      children: [
                        Text('SUBTAREA ${_editedSubtasks.indexOf(subtask) + 1}',
                            style:
                                TextStyle(fontSize: 20, color: Colors.black)),
                        TextFormField(
                          style: TextStyle(color: Colors.black, fontSize: 18),
                          initialValue: subtask.title.toUpperCase(),
                          onChanged: (value) {
                            setState(() {
                              subtask.title = value.toUpperCase();
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
                    subTasks.add(value.id);
                    setState(() {
                      _editedSubtasks.add(value);
                    });
                    print(subTasks);
                  });
                },
                child: Text(
                  'AÑADIR SUBTAREA',
                  style: TextStyle(color: Colors.white, fontSize: 40.0),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 161, 182, 236),
                  onPrimary: Colors.white,
                ),
              ),
              SizedBox(
                  height: 30), // Agrega un espacio adicional entre los campos
              DropdownButtonFormField<String>(
                value: _tipoSeleccionado,
                decoration: InputDecoration(
                  labelText: 'TIPO',
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                items: _opcionesTipo.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _tipoSeleccionado = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty || value == 'TIPO') {
                    return 'POR FAVOR SELECCIONE UN TIPO';
                  }
                  return null;
                },
              ),
              SizedBox(
                  height: 30), // Agrega un espacio adicional entre los campos
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    var _tipo = 'FixedType';
                    if (_tipoSeleccionado == 'DEMANDA') {
                      _tipo = 'RequestType';
                    }
                    Task nuevaTask = Task(
                        id: 'a',
                        title: _tituloController.text.toUpperCase(),
                        description: _descripcionController.text,
                        subtasks: subTasks,
                        type: _tipo,
                        image: "",
                        pictogram: '');

                    controller.createTask(
                        nuevaTask); // Llamar a la función onTaskSaved con la nueva Task
                    Navigator.pop(context, nuevaTask);
                  }
                },
                child: Text(
                  'GUARDAR TAREA',
                  style: TextStyle(color: Colors.white, fontSize: 40.0),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 161, 182, 236),
                  onPrimary: Colors.white,
                ),
              ),
              /*ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    //NOTHING
                    var _tipo = 'FixedType';
                    if (_tipoSeleccionado! == 'DEMANDA') {
                      _tipo = 'RequestType';
                    }

                    Task nuevaTask = Task(
                      id: 'a',
                      title: _tituloController.text,
                      description: _descripcionController.text,
                      subtasks: subTasks,
                      type: _tipo,
                      image: '',
                      pictogram: '',
                    );

                    print(nuevaTask.toJson());
                  }
                },
                child: Text('MOSTRAR TAREA'),
              ),*/
              //SizedBox(
              //  height: 30), // Agrega un espacio adicional entre los campos
            ],
          ),
        ),
      ),
    );
  }
}
