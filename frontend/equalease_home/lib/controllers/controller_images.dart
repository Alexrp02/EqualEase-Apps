import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ImagesController {
  late XFile? _imageFile = null;
  final ImagePicker _picker = ImagePicker();

  /// Pick an image from the given source and temporally store it in the controller
  ///
  /// Params:
  ///
  ///   -[source]: Source of the image, it can be the camera or the gallery (ImageSource).
  ///
  /// Returns: void
  Future<void> pickImage(ImageSource source) async {
    final XFile? selectedImage = await _picker.pickImage(source: source);
    _imageFile = selectedImage;
  }

  void setImageToNull() {
    _imageFile = null;
  }

  bool hasImage() {
    return _imageFile == null;
  }

  /// Upload the previously selected image to the server
  ///
  /// Params:
  ///
  ///   -[folder]: Folder where the image will be stored in the server (String).
  ///   -[filename]: Name of the image file (String).
  ///
  /// Returns: String
  Future<String> uploadImage(String folder, String filename) async {
    if (_imageFile == null) return "";

    try {
      final uri = Uri.parse('http://10.0.2.2:3000/api/image');
      final request = http.MultipartRequest('POST', uri)
        ..files.add(await http.MultipartFile.fromPath(
          'image',
          _imageFile!.path,
          contentType: MediaType('image', 'jpeg'),
        ));
      request.fields['folder'] = folder;
      request.fields['filename'] = filename;

      final response = await request.send();

      if (response.statusCode == 201) {
        print('Image uploaded!');
        // Return the URL of the uploaded image that is in the body of the response
        final Map<String, dynamic> responseData =
            json.decode(await response.stream.bytesToString());
        final String downloadURL = responseData['image'];
        return downloadURL;
      } else {
        print('Upload failed!');
        return "";
      }
    } catch (e) {
      print('Error occurred: $e');
    }
    return "";
  }
}
