import 'package:flutter/material.dart';

class CrearSubtareaForm extends StatefulWidget {
  final Function(String) onSubtareaSaved;

  CrearSubtareaForm({required this.onSubtareaSaved});

  @override
  _CrearSubtareaFormState createState() => _CrearSubtareaFormState();
}

class _CrearSubtareaFormState extends State<CrearSubtareaForm> {
  final _subtareaController = TextEditingController();
  String? _errorText;

  @override
  void dispose() {
    _subtareaController.dispose();
    super.dispose();
  }

  void _saveSubtarea() {
    if (_subtareaController.text.isEmpty) {
      setState(() {
        _errorText = 'Este campo no puede estar vacío';
      });
    } else {
      widget.onSubtareaSaved(_subtareaController.text);
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
              controller: _subtareaController,
              decoration: InputDecoration(
                labelText: 'Subtarea',
                errorText: _errorText,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveSubtarea,
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
