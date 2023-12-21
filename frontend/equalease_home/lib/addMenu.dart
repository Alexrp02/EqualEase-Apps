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
        Menu nuevoMenu = Menu(
          id: 'subid',
          name: _nameController.text.toUpperCase(),
          image: img,
          type: _tipoValue,
        );

        print("El link de la imagen de la nueva subtarea es " + imageURL);

        apiController.createMenu(nuevoMenu);
        Navigator.pop(context, nuevoMenu);
      }
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
              )),
          title: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'AÑADIR MENÚ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 50.0,
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
                labelStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                ),
                helperStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                ),
                errorText: _nameErrorText,
              ),
            ),
            const SizedBox(height: 20),
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
              items: ['Menu', 'Postre']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Tipo',
                labelStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveMenu,
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 161, 182, 236),
                onPrimary: Colors.white,
              ),
              child: const Text(
                'GUARDAR MENÚ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 40.0,
                ),
              ),
            ),
            const SizedBox(height: 20),
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
            const SizedBox(height: 20),
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
              child: const Text(
                'Seleccionar Pictograma',
                style: TextStyle(
                  fontSize: 40.0,
                ),
              ),
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
