import 'package:equalease_home/components/select_pictogram.dart';
import 'package:image_picker/image_picker.dart';
import 'controllers/controller_images.dart';
import 'package:equalease_home/components/upload_image_button.dart';
import 'package:flutter/material.dart';
import 'models/item.dart';
import 'controllers/controller_api.dart';


class CreateItemPage extends StatefulWidget {
  @override
   _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<CreateItemPage> {
  final controller = APIController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _sizeController = TextEditingController();
  final pictogramController = ImagesController();
  String imageURL = '';
  String pictogramURL = '';

 
  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      // Aquí puedes guardar los datos, como enviarlos a una API o guardarlos localmente.
      print('Nombre: ${_nameController.text}');
      print('Cantidad: ${_quantityController.text}');
      print('Tamaño: ${_sizeController.text}');
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
          toolbarHeight: 100.0,
          backgroundColor: Color.fromARGB(255, 161, 182, 236),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
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
                  'CREACIÓN DE OBJETO',
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
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nombre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'POR FAVOR, INGRESA UN NOMBRE';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _quantityController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Cantidad'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'POR FAVOR, INGRESA UNA CANTIDA';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _sizeController,
                decoration: InputDecoration(labelText: 'Tamaño'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'POR FAVOR, INGRESA UNA TAMAÑO';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
             ImageUploader(
                 source: ImageSource.camera, controller: pictogramController),
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
                    child: Text('Seleccionar Pictograma'))
              ,
              ElevatedButton(
                onPressed: () async{
                  if (_formKey.currentState!.validate()) {
                    Item newItem = Item(
                        id: 'a',
                        name: _nameController.text.toUpperCase(),
                         quantity: int.parse(_quantityController.text), // Convertir a tipo numérico
                        size: _sizeController.text,
                        pictogram: pictogramURL);

                    newItem.id = await controller.createItem( newItem); // Llamar a la función onItemSaved con la nueva Task
                    Navigator.pop(context, newItem);
                  }
                },
                child: Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
