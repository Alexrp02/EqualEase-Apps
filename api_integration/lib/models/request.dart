import 'dart:convert';

class Request {
  String id;
  String assignedStudent;
  List<String> items;

  Request(
      {required this.id, required this.assignedStudent, required this.items});

  factory Request.fromMap(Map<String, dynamic> json) => Request(
      id: json['id'],
      assignedStudent: json['assignedStudent'],
      items: List<String>.from(json['items']));

  factory Request.fromJson(String str) => Request.fromMap(json.decode(str));

  Map<String, dynamic> toMap() {
    return {'id': id, 'assignedStudent': assignedStudent, 'items': items};
  }

  String toJson() => json.encode(toMap());

  // Necesario cuando se quiera crear una nueva tarea, puesto
  // que el id es asignado automáticamente
  String toJsonWithoutId() {
    Map<String, dynamic> data = {
      'assignedStudent': assignedStudent,
      'items': items
    };
    return json.encode(data);
  }
}
