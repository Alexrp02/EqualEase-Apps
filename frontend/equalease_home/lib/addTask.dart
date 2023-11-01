import 'package:flutter/material.dart';
import 'addSubtask.dart';
import 'task.dart'; // Importar la clase Tarea

class AgregarTareaPage extends StatefulWidget {
  final Function(Tarea) onTareaSaved; // Ajusta el tipo de parámetro

  AgregarTareaPage({required this.onTareaSaved});

  @override
  _AgregarTareaPageState createState() => _AgregarTareaPageState();
}

class _AgregarTareaPageState extends State<AgregarTareaPage> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _descripcionController = TextEditingController();
  List<String> subtareas = [];
  int contador = 1;
  final _tipoController = TextEditingController();

  @override
  void dispose() {
    _tituloController.dispose();
    _descripcionController.dispose();
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
                  if (_formKey.currentState!.validate()) {
                    Tarea nuevaTarea = Tarea( // Crear una nueva instancia de Tarea
                      titulo: _tituloController.text,
                      descripcion: _descripcionController.text,
                      subtareas: subtareas,
                      tipo: _tipoController.text,
                    );
                    widget.onTareaSaved(nuevaTarea); // Llamar a la función onTareaSaved con la nueva tarea
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
}
