import 'package:flutter/material.dart';

class CrearSubtareaForm extends StatefulWidget {
  @override
  _CrearSubtareaFormState createState() => _CrearSubtareaFormState();
}

class _CrearSubtareaFormState extends State<CrearSubtareaForm> {
  final _subtareaController = TextEditingController();

  @override
  void dispose() {
    _subtareaController.dispose();
    super.dispose();
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
              ),
              validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese una subtarea';
                  }
                  return null;
                },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Add functionality for saving subtask
                Navigator.pop(context, _subtareaController.text);
              },
              child: Text('Guardar Subtarea'),
            ),
          ],
        ),
      ),
    );
  }
}
