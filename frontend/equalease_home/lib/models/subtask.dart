import 'dart:convert';

class Subtask {
  String id;
  String title;
  String description;
  String image;
  String pictogram;
  String audio;
  String video;

  Subtask({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.pictogram,
    required this.audio,
    required this.video,
  });

  factory Subtask.fromMap(Map<String, dynamic> json) => Subtask(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      image: json['image'],
      pictogram: json['pictogram'],
      audio: json['audio'],
      video: json['video']);

  factory Subtask.fromJson(String str) => Subtask.fromMap(json.decode(str));

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image': image,
      'pictogram': pictogram,
      'audio': audio,
      'video': video
    };
  }

  String toJson() => json.encode(toMap());

  String toJsonWithoutId() {
    Map<String, dynamic> data = {
      'title': title,
      'description': description,
      'image': image,
      'pictogram': pictogram,
      'audio': audio,
      'video': video
    };
    return json.encode(data);
  }

  // ... Resto del código ...
}
