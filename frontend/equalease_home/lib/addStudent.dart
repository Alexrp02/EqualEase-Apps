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
  String? _passwordErrorText;
  List<String> _passwordElements = [];
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
      return;
    }

    if (_surnameController.text.isEmpty) {
      setState(() {
        _surnameErrorText = 'ESTE CAMPO NO PUEDE ESTAR VACÍO';
      });
      return;
    }

    if (_passwordElements.length != 3) {
      setState(() {
        _passwordErrorText = 'Debe seleccionar exactamente 3 elementos para la contraseña';
      });
      return;
    }

    if (imageController.hasImage()) {
      img = pictogramURL;
    } else if (!imageController.hasImage()) {
      img = await imageController.uploadImage('student', _nameController.text);
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
      return;
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
        //password: _passwordElements.join(''),
      );

      apiController.createStudent(nuevoStudent, _passwordElements.join(''));
      Navigator.pop(context, nuevoStudent);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0),
        child: AppBar(
          actions: [
            // Agrega el botón de cerrar sesión en el AppBar
            IconButton(
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              icon: Icon(
                Icons.exit_to_app,
                size: 70.0,
              ),
            ),
          ],
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
            _buildPasswordSelection(),
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

  Widget _buildPasswordSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Selecciona tres elementos para la contraseña:',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          children: _buildPasswordOptions(),
        ),
        const SizedBox(height: 10),
        if (_passwordElements.length == 3)
          Text(
            'Contraseña actual: ${_passwordElements.join()}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        if (_passwordErrorText != null)
          Text(
            _passwordErrorText!,
            style: TextStyle(
              color: Colors.red,
            ),
          ),
      ],
    );
  }

  List<Widget> _buildPasswordOptions() {
    return ['coche', 'botella', 'circulo', 'casa', 'planta', 'vaso']
        .map<Widget>((String option) {
      return ChoiceChip(
        label: Text(option),
        selected: _passwordElements.contains(option),
        onSelected: (bool selected) {
          setState(() {
            if (selected) {
              _passwordElements.add(option);
            } else {
              _passwordElements.remove(option);
            }
          });
        },
      );
    }).toList();
  }
}
