import 'dart:convert';

import 'package:equalease_home/models/subtask.dart';

class Task {
  String id;
  String title;
  String description;
  List<Subtask> subtasks;
  String type;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.subtasks,
    required this.type,
  });

  factory Task.fromMap(Map<String, dynamic> json) => Task(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        subtasks: json['subtasks'],
        type: json['type'],
        // images: json['images'],
        // pictograms: json['pictograms']
      );

  factory Task.fromJson(String str) => Task.fromMap(json.decode(str));

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'description': description,
        'subtasks': subtasks,
        'type': type,
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
      'subtasks': subtasks,
      // 'images': images,
      // 'pictograms': pictograms
    };
    return json.encode(data);
  }
}
