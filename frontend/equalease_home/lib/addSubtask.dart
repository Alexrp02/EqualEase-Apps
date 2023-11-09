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
        _titleErrorText = 'ESTE CAMPO NO PUEDE ESTAR VACIO';
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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0),
        child: AppBar(
          backgroundColor: Color.fromARGB(255, 161, 182, 236),
          title: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'CREAR SUBTAREA',
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'TITULO',
                labelStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
                errorText: _titleErrorText,
              ),
              style: TextStyle(
                color: Colors.black,
                fontSize: 18.0,
              ),
            ),
            SizedBox(height: 30),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'DESCRIPCION',
                labelStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
                errorText: _descriptionErrorText,
              ),
              style: TextStyle(
                color: Colors.black,
                fontSize: 18.0,
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: _saveSubtask,
              child: Text(
                'GUARDAR SUBTAREA',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 161, 182, 236),
                onPrimary: Colors.white,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                //pickImage();
              },
              child: Text(
                'SELECCIONAR IMAGEN',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 161, 182, 236),
                onPrimary: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
