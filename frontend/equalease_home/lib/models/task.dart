import 'dart:convert';

class Task {
  String id;
  String title;
  String description;
  List<String> subtasks;
  String image;
  String pictogram;
  String type; // "FixedType" || "RequestType"

  Task(
      {required this.id,
      required this.title,
      required this.description,
      required this.subtasks,
      required this.image,
      required this.pictogram,
      required this.type});

  factory Task.fromMap(Map<String, dynamic> json) => Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      subtasks: List<String>.from(json['subtasks']),
      image: json['image'],
      pictogram: json['pictogram'],
      type: json['type']);

  factory Task.fromJson(String str) => Task.fromMap(json.decode(str));

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'subtasks': subtasks,
      'image': image,
      'pictogram': pictogram,
      'type': type
    };
  }

  String toJson() => json.encode(toMap());

  // ... Resto del código ...
}