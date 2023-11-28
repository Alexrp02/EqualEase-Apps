import 'dart:io';

import 'package:flutter/material.dart';
import 'package:equalease_home/components/select_pictogram.dart';
import 'package:equalease_home/components/upload_image_button.dart';
import 'package:image_picker/image_picker.dart';
import 'controllers/controller_images.dart';
import 'models/menu.dart';
import 'controllers/controller_api.dart';

class AddMenuForm extends StatefulWidget {
  @override
  _AddMenuFormState createState() => _AddMenuFormState();
}

class _AddMenuFormState extends State<AddMenuForm> {
  //final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  String _tipoValue = 'Menu';
  final imageController = ImagesController();
  final apiController = APIController();
  String imageURL = '';
  String pictogramURL = '';
  String? _nameErrorText;
  bool _imgError = false;

  @override
  void dispose() {
    _nameController.dispose();
    //_descriptionController.dispose();
    super.dispose();
  }

  void _saveMenu() async {
    String img = '';

    if (_nameController.text.isEmpty) {
      setState(() {
        _nameErrorText = 'ESTE CAMPO NO PUEDE ESTAR VACIO';
      });
    } else {
      if (imageController.hasImage()) {
        //si no tiene imagen
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
                  'Debe seleccionar una imagen o un pictograma obligatoriamente.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        if (_nameController.text.isEmpty) {
          setState(() {
            _nameErrorText = 'ESTE CAMPO NO PUEDE ESTAR VACIO';
          });
        } else {
          Menu nuevoMenu = Menu(
            id: 'subid', // Proporciona un ID adecuado para la subtarea
            name: _nameController.text
                .toUpperCase(), // Utiliza el título del campo de texto para el título de la subtarea
            image: img,
            type: _tipoValue,
          );

          print("El link de la imagen de la nueva subtarea es " + imageURL);

          apiController.createMenu(nuevoMenu);
          Navigator.pop(context, nuevoMenu);
        }

        //apiController.createMenu(nuevoMenu).then((value) {
        //nuevaSubtarea = value;
        //  Navigator.pop(context);
        //}); // Utiliza la función post para crear una nueva subtarea
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Añadir Menú'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                    labelText: 'Nombre', errorText: _nameErrorText),
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _tipoValue,
                onChanged: (String? value) {
                  setState(() {
                    _tipoValue = value!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, seleccione el tipo';
                  }
                  return null;
                },
                items: ['Menu', 'Dessert']
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
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveMenu,
                child: Text(
                  'GUARDAR MENU',
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
                Image.file(File(imageController.getImage()!.path),
                    fit: BoxFit.contain, width: 300,height: 300)
              else if (pictogramURL != '')
                Image.network(pictogramURL, fit: BoxFit.contain, width: 300,height: 300)
              else
                const Text('No se ha seleccionado ninguna imagen'),
            ],
          ),
        ),
      ),
    );
  }
}
