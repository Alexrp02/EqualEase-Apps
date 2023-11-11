import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../controllers/controller_images.dart';

class ImageUploader extends StatefulWidget {
  final ImageSource source;
  final ImagesController controller;
  const ImageUploader(
      {super.key, required this.source, required this.controller});

  @override
  _ImageUploaderState createState() => _ImageUploaderState();
}

class _ImageUploaderState extends State<ImageUploader> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () async {
          await widget.controller.pickImage(widget.source);
        },
        child: Text('Elegir imagen'));
  }
}
