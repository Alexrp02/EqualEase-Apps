import 'dart:io';

import 'package:flutter/material.dart';
import 'package:equalease_home/models/student.dart';
import 'package:equalease_home/models/teacher.dart';
import 'package:equalease_home/controllers/controller_api.dart';
import 'package:equalease_home/components/upload_image_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:equalease_home/controllers/controller_images.dart';
import 'package:equalease_home/components/select_pictogram.dart';

class EditTeacherDataPage extends StatefulWidget {
  final Teacher teacher;

  EditTeacherDataPage({required this.teacher});

  @override
  _EditTeacherPageState createState() => _EditTeacherPageState();
}

class _EditTeacherPageState extends State<EditTeacherDataPage> {
  late TextEditingController _nameController = TextEditingController();
  late TextEditingController _surnameController = TextEditingController();
  late TextEditingController _mailController = TextEditingController();
  String _tipoValue = 'No';
  final imageController = ImagesController();
  final apiController = APIController();
  String imageURL = '';
  String pictogramURL = '';
  String? _nameErrorText;
  String? _surnameErrorText;
  String? _mailErrorText;
  bool _imgError = false;
  bool _isAdmin = false; // Agrega esta línea

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.teacher.name);
    _surnameController = TextEditingController(text: widget.teacher.surname);
    _mailController = TextEditingController(text: widget.teacher.email);
    if (widget.teacher.isAdmin) {
      _tipoValue = 'Si';
      _isAdmin = true;
    } else {
      _tipoValue = 'No';
      _isAdmin = false;
    }

    pictogramURL = widget.teacher.profilePicture;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _mailController.dispose();
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
          leading: new IconButton(
              onPressed: () {
                Navigator.pop(context, widget.teacher);
              },
              icon: new Icon(
                Icons.arrow_back,
                size: 50.0,
              )),
          title: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'EDITAR DATOS DE ${widget.teacher.name.toUpperCase()}',
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                    labelText: 'Nombre', errorText: _nameErrorText),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _surnameController,
                decoration: InputDecoration(
                    labelText: 'Apellidos', errorText: _surnameErrorText),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _mailController,
                decoration: InputDecoration(
                    labelText: 'Mail', errorText: _mailErrorText),
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _tipoValue,
                onChanged: (value) {
                  setState(() {
                    _tipoValue = value!;
                    _isAdmin = _tipoValue == 'Si';
                  });
                },
                items:
                    ['Si', 'No'].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: '¿Es administrador?',
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
                            MaterialPageRoute(
                                builder: (context) => PictogramSelect()))
                        .then((value) {
                      pictogramURL = value;
                    });
                  },
                  child: Text('Seleccionar Pictograma')),
              ElevatedButton(
                onPressed: () {
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
      ),
    );
  }

  void _saveChanges() async {
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
            await imageController.uploadImage('teacher', _nameController.text);
      }

      widget.teacher.name = _nameController.text;
      widget.teacher.surname = _surnameController.text;
      widget.teacher.profilePicture = img;
      widget.teacher.isAdmin = _isAdmin;

      print("El link de la imagen de la nueva imagen es " + img);

      apiController.updateTeacher(widget.teacher);
      Navigator.pop(context, widget.teacher);
    }
  }
}
