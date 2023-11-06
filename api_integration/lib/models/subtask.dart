// Herramientas para convertir JSON a Dart:
// https://javiercbk.github.io/json_to_dart/
// https://app.quicktype.io/

// Encoders and decoders for converting between different data representations, including JSON and UTF-8.
// includes jsonEncode() and jsonDecode() methods
import 'dart:convert';

class Subtask {
  Subtask({
    required this.id,
    required this.title,
    required this.description,
    // required this.images,
    // required this.pictograms
  });

  String id;
  String title;
  String description;
  // List<dynamic> images;
  // List<dynamic> pictograms;

  // factory methods:
  // En Dart, los métodos que actúan como constructores se definen utilizando la palabra
  // clave factory. Cuando defines un constructor con factory, estás indicando que ese
  // constructor se utiliza para crear instancias de la clase, pero no es necesario que
  // siempre se llame al constructor para crear una nueva instancia.

  // Internamente, los json se interpretan en dart como Map<String, dynamic>

  factory Subtask.fromMap(Map<String, dynamic> json) => Subtask(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        // images: json['images'],
        // pictograms: json['pictograms']
      );

  factory Subtask.fromJson(String str) => Subtask.fromMap(json.decode(str));

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'description': description,
        // 'images': images,
        // 'pictograms': pictograms
      };

  String toJson() => json.encode(toMap());

  // Necesario cuando se quiera crear una nueva tarea, puesto
  // que el id es asignado automáticamente
  String toJsonWithoutId() {
    Map<String, dynamic> data = {
      'title': title,
      'description': description,
      // 'images': images,
      // 'pictograms': pictograms
    };
    return json.encode(data);
  }
}
