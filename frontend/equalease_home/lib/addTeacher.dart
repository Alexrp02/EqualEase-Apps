import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'controllers/controller_api.dart';
import 'controllers/controller_images.dart';
import 'models/student.dart';
import 'models/teacher.dart';
import 'package:equalease_home/components/select_pictogram.dart';
import 'package:equalease_home/components/upload_image_button.dart';
import 'dart:io';

class AddTeacherForm extends StatefulWidget {
  @override
  _AddTeacherFormState createState() => _AddTeacherFormState();
}

class _AddTeacherFormState extends State<AddTeacherForm> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _surnameController = TextEditingController();
  TextEditingController _mailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  String _tipoValue = 'No';
  final imageController = ImagesController();
  final apiController = APIController();
  String imageURL = '';
  String pictogramURL = '';
  String? _nameErrorText;
  String? _surnameErrorText;
  String? _mailErrorText;
  bool _imgError = false;

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _mailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _saveMenu() async {
    String img = '';

    if (_nameController.text.isEmpty) {
      setState(() {
        _nameErrorText = 'ESTE CAMPO NO PUEDE ESTAR VACÍO';
      });
      return;
    }

    if (_surnameController.text.isEmpty) {
      setState(() {
        _surnameErrorText = 'ESTE CAMPO NO PUEDE ESTAR VACÍO';
      });
      return;
    }

    if (_mailController.text.isEmpty) {
      setState(() {
        _mailErrorText = 'ESTE CAMPO NO PUEDE ESTAR VACÍO';
      });
      return;
    }

    if (_passwordController.text.isEmpty || _confirmPasswordController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Aviso'),
            content: const Text(
              'Por favor, complete ambos campos de contraseña.',
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
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Aviso'),
            content: const Text(
              'Las contraseñas no coinciden. Por favor, inténtelo de nuevo.',
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
      return;
    }

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
      bool admin = false;
      String rol = 'teacher';
      if (_tipoValue == 'Si') {
        admin = true;
        rol = 'admin';
      }

      // Ahora también se recoge la contraseña
      String password = _passwordController.text;

      Teacher nuevoTeacher = Teacher(
        id: 'subid',
        name: _nameController.text,
        surname: _surnameController.text,
        email: _mailController.text,
        students: [],
        profilePicture: img,
        isAdmin: admin,
      );

      apiController.createTeacher(nuevoTeacher, password, rol);
      Navigator.pop(context, nuevoTeacher);
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
                  'AÑADIR DOCENTE',
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
            TextFormField(
              controller: _mailController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, ingrese el mail';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: 'Mail',
                errorText: _mailErrorText,
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, ingrese la contraseña';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: 'Contraseña',
              ),
            ),
            TextFormField(
              controller: _confirmPasswordController,
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, confirme la contraseña';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: 'Confirmar Contraseña',
              ),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _tipoValue,
              onChanged: (String? value) {
                setState(() {
                  _tipoValue = value ?? 'No';
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, seleccione el rol';
                }
                return null;
              },
              items: ['No', 'Si'].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: '¿Es administrador?',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveMenu,
              child: const Text(
                'GUARDAR DOCENTE',
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
