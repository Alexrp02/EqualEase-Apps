import 'dart:convert';

import 'package:equalease_home/models/task.dart';

/*
  Student model
  Student attributes:
    -id
    -name
    -??
    
*/

class Student {
  String id;
  String name;
  List<String> pendingTasks;

  Student({
    required this.id,
    required this.name,
    required this.pendingTasks
  });

  factory Student.fromMap(Map<String, dynamic> json) => Student(
        id: json['id'],
        name: json['name'],
        pendingTasks: List<String>.from(json['pendingTasks']),
        // images: json['images'],
        // pictograms: json['pictograms']
  );

  factory Student.fromJson(String str) => Student.fromMap(json.decode(str));

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'pendingTasks': pendingTasks
  };

  String toJson() => json.encode(toMap());

  // Necesario cuando se quiera crear una nueva tarea, puesto
  // que el id es asignado automáticamente
  String toJsonWithoutId() {
    Map<String, dynamic> data = {
      'name': name,
      'pendingTasks':pendingTasks
    };
    return json.encode(data);
  }

}