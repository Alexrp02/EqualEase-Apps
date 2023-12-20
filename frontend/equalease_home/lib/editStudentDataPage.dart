import 'dart:io';

import 'package:flutter/material.dart';
import 'package:equalease_home/models/student.dart';
import 'package:equalease_home/controllers/controller_api.dart';
import 'package:equalease_home/components/upload_image_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:equalease_home/controllers/controller_images.dart';
import 'package:equalease_home/components/select_pictogram.dart';

class EditStudentDataPage extends StatefulWidget {
  final Student student;

  EditStudentDataPage({required this.student});

  @override
  _EditStudentPageState createState() => _EditStudentPageState();
}

class _EditStudentPageState extends State<EditStudentDataPage> {
  late TextEditingController _nameController;
  late TextEditingController _surnameController;
  late TextEditingController _tipoController;
  final APIController _controller = APIController();
  final imageController = ImagesController();
  String pictogramURL = '';
  String? _nameErrorText;
  String? _surnameErrorText;
  String _tipoValue = 'text'; // Valor predeterminado

  @override
  void initState() {
    super.initState();
    // Inicializa los controladores de texto con los valores actuales del estudiante
    _nameController = TextEditingController(text: widget.student.name);
    _surnameController = TextEditingController(text: widget.student.surname);
    _tipoController = TextEditingController(text: _tipoValue);
    pictogramURL = widget.student.profilePicture;
  }

  @override
  void dispose() {
    // Libera los recursos de los controladores de texto al cerrar la página
    _nameController.dispose();
    _surnameController.dispose();
    _tipoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0),
        child: AppBar(
          toolbarHeight: 100.0,
          backgroundColor: Color.fromARGB(255, 161, 182, 236),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context, widget.student);
            },
            icon: Icon(
              Icons.arrow_back,
              size: 50.0,
            ),
          ),
          title: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'EDITAR DATOS DE ${widget.student.name.toUpperCase()}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 50.0,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Nombre',
                errorText: _nameErrorText,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _surnameController,
              decoration: InputDecoration(
                labelText: 'Apellidos',
                errorText: _surnameErrorText,
              ),
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _tipoValue,
              onChanged: (value) {
                setState(() {
                  _tipoValue = value!;
                });
              },
              items: ['text', 'video', 'image', 'audio']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Tipo de representación',
              ),
            ),
            SizedBox(height: 20),
            ImageUploader(
              source: ImageSource.camera,
              controller: imageController,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PictogramSelect()),
                ).then((value) {
                  pictogramURL = value;
                });
              },
              child: Text('Seleccionar Pictograma'),
            ),
            ElevatedButton(
              onPressed: () {
                // Guarda los cambios y vuelve a la página anterior
                _saveChanges();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 161, 182, 236),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
              child: Text('Guardar Cambios'),
            ),
            if (imageController.getImage() != null)
              Image.file(
                File(imageController.getImage()!.path),
                fit: BoxFit.contain,
                width: 300,
                height: 300,
              )
            else if (pictogramURL != '')
              Image.network(
                pictogramURL,
                fit: BoxFit.contain,
                width: 300,
                height: 300,
              )
            else
              const Text('No se ha seleccionado ninguna imagen'),
          ],
        ),
      ),
    );
  }

  void _saveChanges() async {
    // Actualiza los valores del estudiante con los nuevos valores ingresados
    String img = '';

    if (_nameController.text.isEmpty) {
      setState(() {
        _nameErrorText = 'ESTE CAMPO NO PUEDE ESTAR VACÍO';
      });
    } else if (_surnameController.text.isEmpty) {
      setState(() {
        _surnameErrorText = 'ESTE CAMPO NO PUEDE ESTAR VACÍO';
      });
    } else {
      if (imageController.hasImage()) {
        img = pictogramURL;
      } else if (!imageController.hasImage()) {
        img =
            await imageController.uploadImage('student', _nameController.text);
      }

      widget.student.name = _nameController.text;
      widget.student.surname = _surnameController.text;
      widget.student.profilePicture = img;
      widget.student.representation = _tipoValue;

      print("El link de la imagen de la nueva imagen es " + img);

      // Llamada al controlador para guardar internamente los cambios
      _controller.updateStudent(widget.student);
      Navigator.pop(context, widget.student);
    }
  }
}
