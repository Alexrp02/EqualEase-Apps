import 'package:flutter/material.dart';
import 'package:equalease_home/components/select_pictogram.dart';
import 'package:equalease_home/components/upload_image_button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'controllers/controller_images.dart';

class AddMenuForm extends StatefulWidget {
  @override
  _AddMenuFormState createState() => _AddMenuFormState();
}

class _AddMenuFormState extends State<AddMenuForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nombreController = TextEditingController();
  String _tipoValue = 'Menu'; // Inicializado con un valor por defecto
  final imageController = ImagesController();
  String imageURL = '';
  String pictogramURL = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Añadir Menú'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nombreController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese el nombre';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Nombre',
                ),
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
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Si el formulario es válido, puedes procesar los datos aquí
                    // por ejemplo, enviarlos a una base de datos o realizar otra acción.
                    // Puedes acceder a los valores ingresados con _nombreController.text y _tipoValue
                  }
                },
                child: Text('Guardar'),
              ),
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
            ],
          ),
        ),
      ),
    );
  }
}
