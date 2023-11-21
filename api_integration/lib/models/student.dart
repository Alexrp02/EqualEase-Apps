import 'dart:convert';

class Student {
  String id;
  String name;
  String surname;
  List<String> pendingTasks;
  List<String> doneTasks;
  String profilePicture; // Agregar la propiedad para la imagen de perfil.
  bool hasRequest;
  bool hasKitchenOrder;

  Student({
    required this.id,
    required this.name,
    required this.surname,
    required this.pendingTasks,
    required this.doneTasks,
    required this.profilePicture,
    required this.hasRequest,
    required this.hasKitchenOrder,
  });

  factory Student.fromMap(Map<String, dynamic> json) => Student(
      id: json['id'],
      name: json['name'],
      surname: json['surname'],
      pendingTasks: List<String>.from(json['pendingTasks']),
      doneTasks: List<String>.from(json['doneTasks']),
      profilePicture: json['profilePicture'],
      hasRequest: json['hasRequest'],
      hasKitchenOrder: json['hasKitchenOrder']);

  factory Student.fromJson(String str) => Student.fromMap(json.decode(str));

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'surname': surname,
      'pendingTasks': pendingTasks,
      'doneTasks': doneTasks,
      'profilePicture': profilePicture,
      'hasRequest': hasRequest,
      'hasKitchenOrder': hasKitchenOrder
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
      'hasKitchenOrder': hasKitchenOrder
    };
    return json.encode(data);
  }
}
