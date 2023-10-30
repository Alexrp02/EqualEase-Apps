import 'package:flutter/material.dart';
import 'addSubtask.dart';

class AgregarTareaPage extends StatefulWidget {
  @override
  _AgregarTareaPageState createState() => _AgregarTareaPageState();
}

class _AgregarTareaPageState extends State<AgregarTareaPage> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _descripcionController = TextEditingController();
  List<String> subtareas = [];
  int contador = 1;
  //final _subtareasController = TextEditingController();
  final _tipoController = TextEditingController();
  // File? _image;

  @override
  void dispose() {
    _tituloController.dispose();
    _descripcionController.dispose();
    //_subtareasController.dispose();
    _tipoController.dispose();
    super.dispose();
  }

  void _addSubtarea(String subtarea) {
    setState(() {
      subtareas.add('Subtarea $contador: $subtarea');
      contador++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Tarea'),
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
                'Subtareas:',
              ),
              for (var subtarea in subtareas) Text(subtarea),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CrearSubtareaForm(
                        onSubtareaSaved: _addSubtarea,
                      ),
                    ),
                  );
                },
                child: Text('Añadir Subtarea'),
              ),
              TextFormField(
                controller: _tipoController,
                decoration: InputDecoration(
                  labelText: 'Tipo',
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  //pickImage();
                },
                child: Text('Seleccionar Imagen'),
              ),
              // _image != null
              //     ? Image.file(_image!)
              //     : SizedBox(
              //         height: 100,
              //       ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Add functionality for saving task
                    // AÑADIR AQUI EL INGRESO DE DATOS A LA BASE DE DATOS
                    Navigator.pop(context);
                  }
                },
                child: Text('Guardar Tarea'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Future<void> _pickImage() async {
  //   final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
  //   if (pickedFile != null) {
  //     setState(() {
  //       _image = File(pickedFile.path);
  //     });
  //   }
  // }
}
