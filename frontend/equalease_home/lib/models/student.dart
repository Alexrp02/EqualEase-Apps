import 'dart:convert';

// Constantes globales de representacion:
// Student.representation ["text", "audio", "image", "video"]

class Student {
  String id;
  String name;
  String surname;
  List<Map<String, dynamic>> pendingTasks;
  List<String> doneTasks;
  String profilePicture; // Agregar la propiedad para la imagen de perfil.
  bool hasRequest;
  bool hasKitchenOrder;
  String representation;

  Student(
      {required this.id,
      required this.name,
      required this.surname,
      required this.pendingTasks,
      required this.doneTasks,
      required this.profilePicture,
      required this.hasRequest,
      required this.hasKitchenOrder,
      required this.representation});

  factory Student.fromMap(Map<String, dynamic> json) => Student(
      id: json['id'],
      name: json['name'],
      surname: json['surname'],
      pendingTasks: _parsePendingTasks(json['pendingTasks']),
      doneTasks: List<String>.from(json['doneTasks']),
      profilePicture: json['profilePicture'],
      hasRequest: json['hasRequest'] || false,
      hasKitchenOrder: json['hasKitchenOrder'] || false,
      representation: json['representation'] ?? '');

  factory Student.fromJson(String str) => Student.fromMap(json.decode(str));

  static List<Map<String, dynamic>> _parsePendingTasks(dynamic tasksJson) {
    if (tasksJson is List) {
      return tasksJson.cast<Map<String, dynamic>>();
    } else if (tasksJson is Map<String, dynamic>) {
      // Handle the case where 'pendingTasks' is a single task, convert it to a list
      return [tasksJson];
    } else {
      // Handle other cases or return an empty list
      return [];
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'surname': surname,
      'pendingTasks': pendingTasks,
      'doneTasks': doneTasks,
      'profilePicture': profilePicture,
      'hasRequest': hasRequest,
      'hasKitchenOrder': hasKitchenOrder,
      'representation': representation
    };
  }

  String toJson() => json.encode(toMap());

  // Necesario cuando se quiera crear una nueva tarea, puesto
  // que el id es asignado automáticamente
  String toJsonWithoutId() {
    Map<String, dynamic> data = {
      'name': name,
      'surname': surname,
      'pendingTasks': pendingTasks,
      'doneTasks': doneTasks,
      'profilePicture': profilePicture,
      'hasRequest': hasRequest,
      'hasKitchenOrder': hasKitchenOrder,
      'representation': representation
    };
    return json.encode(data);
  }
}
