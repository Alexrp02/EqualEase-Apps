import 'package:flutter/material.dart';
import 'models/subtask.dart';
import 'controllers/controllerSubstask.dart';

class CrearSubtaskForm extends StatefulWidget {
  final Function(String) onSubtaskSaved;

  CrearSubtaskForm({required this.onSubtaskSaved});

  @override
  _CrearSubtaskFormState createState() => _CrearSubtaskFormState();
}

class _CrearSubtaskFormState extends State<CrearSubtaskForm> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _titleErrorText;
  String? _descriptionErrorText;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveSubtask() async {
    if (_titleController.text.isEmpty) {
      setState(() {
        _titleErrorText = 'Este campo no puede estar vacío';
      });
    } else {
      Subtask nuevaSubtarea = Subtask(
        id: 'subid', // Proporciona un ID adecuado para la subtarea
        title: _titleController
            .text, // Utiliza el título del campo de texto para el título de la subtarea
        description: _descriptionController.text,
      );

      createSubtask(nuevaSubtarea).then((value) => Navigator.pop(
          context,
          nuevaSubtarea
              .id)); // Utiliza la función post para crear una nueva subtarea
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Subtarea'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Título',
                errorText: _titleErrorText,
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Descripción',
                errorText: _descriptionErrorText,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveSubtask,
              child: Text('Guardar Subtarea'),
            ),
            ElevatedButton(
              onPressed: () {
                //pickImage();
              },
              child: Text('Seleccionar Imagen'),
            ),
          ],
        ),
      ),
    );
  }
}
