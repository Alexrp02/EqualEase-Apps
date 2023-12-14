import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'controllers/controller_api.dart';
import 'controllers/controller_images.dart';
import 'models/student.dart';
import 'package:equalease_home/components/select_pictogram.dart';
import 'package:equalease_home/components/upload_image_button.dart';
import 'dart:io';

class AddStudentForm extends StatefulWidget {
  @override
  _AddStudentFormState createState() => _AddStudentFormState();
}

class _AddStudentFormState extends State<AddStudentForm> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _surnameController = TextEditingController();
  String _tipoValue = 'text';
  final imageController = ImagesController();
  final apiController = APIController();
  String imageURL = '';
  String pictogramURL = '';
  String? _nameErrorText;
  String? _surnameErrorText;
  bool _imgError = false;

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    super.dispose();
  }

  void _saveMenu() async {
    String img = '';

    if (_nameController.text.isEmpty) {
      setState(() {
        _nameErrorText = 'ESTE CAMPO NO PUEDE ESTAR VACÍO';
      });
    } else {
      if (imageController.hasImage()) {
        img = pictogramURL;
      } else if (!imageController.hasImage()) {
        img = await imageController.uploadImage('menu', _nameController.text);
      }

      if (img == '') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Aviso'),
              content: const Text(
                'Debe seleccionar una imagen o un pictograma obligatoriamente.',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        Student nuevoStudent = Student(
          id: 'subid',
          name: _nameController.text,
          surname: _surnameController.text,
          pendingTasks: [],
          doneTasks: [],
          profilePicture: img,
          hasRequest: false,
          hasKitchenOrder: false,
          representation: _tipoValue,
        );

        apiController.createStudent(nuevoStudent, 'cochebotellaplanta');
        Navigator.pop(context, nuevoStudent);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0),
        child: AppBar(
          backgroundColor: Color.fromARGB(255, 161, 182, 236),
          toolbarHeight: 100.0,
          leading: new IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: new Icon(
              Icons.arrow_back,
              size: 50.0,
            ),
          ),
          title: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'AÑADIR ESTUDIANTE',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 30.0,
                  ),
                ),
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
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, ingrese el nombre';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: 'Nombre',
                errorText: _nameErrorText,
              ),
            ),
            TextFormField(
              controller: _surnameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, ingrese el apellido';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: 'Apellido',
                errorText: _surnameErrorText,
              ),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _tipoValue,
              onChanged: (String? value) {
                setState(() {
                  _tipoValue = value ?? 'text';
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, seleccione el tipo';
                }
                return null;
              },
              items: ['text', 'video', 'image', 'audio']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Tipo',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveMenu,
              child: const Text(
                'GUARDAR ESTUDIANTE',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 161, 182, 236),
                onPrimary: Colors.white,
              ),
            ),
            ImageUploader(
              source: ImageSource.camera,
              controller: imageController,
              onImageSelected: () {
                setState(() {
                  imageURL = imageController.getImage()!.path;
                  pictogramURL = '';
                });
              },
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PictogramSelect()),
                ).then((value) {
                  setState(() {
                    pictogramURL = value;
                    imageURL = '';
                    imageController.setImageToNull();
                  });
                });
              },
              child: const Text('Seleccionar Pictograma'),
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
}
