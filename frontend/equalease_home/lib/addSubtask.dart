import 'package:flutter/material.dart';

class CrearSubtaskForm extends StatefulWidget {
  final Function(String) onSubtaskSaved;

  CrearSubtaskForm({required this.onSubtaskSaved});

  @override
  _CrearSubtaskFormState createState() => _CrearSubtaskFormState();
}

class _CrearSubtaskFormState extends State<CrearSubtaskForm> {
  final _subtaskController = TextEditingController();
  String? _errorText;

  @override
  void dispose() {
    _subtaskController.dispose();
    super.dispose();
  }

  void _saveSubtask() {
    if (_subtaskController.text.isEmpty) {
      setState(() {
        _errorText = 'Este campo no puede estar vacio';
      });
    } else {
      widget.onSubtaskSaved(_subtaskController.text);
      Navigator.pop(context);
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
              controller: _subtaskController,
              decoration: InputDecoration(
                labelText: 'Subtask',
                errorText: _errorText,
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
              // _image != null
              //     ? Image.file(_image!)
              //     : SizedBox(
              //         height: 100,
              //       ),
          ],
        ),
      ),
    );
  }
}
