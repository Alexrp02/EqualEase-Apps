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
  String? _tipoSeleccionado;
  final List<String> _opcionesTipo = ['Fija', 'Demanda']; // Opciones de tipo

  @override
  void dispose() {
    _tituloController.dispose();
    _descripcionController.dispose();
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
                    Tarea nuevaTarea = Tarea( // Crear una nueva instancia de Tarea
                      titulo: _tituloController.text,
                      descripcion: _descripcionController.text,
                      subtareas: subtareas,
                      tipo: _tipoSeleccionado!,
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
