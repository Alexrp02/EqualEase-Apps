import 'dart:convert';

class Menu {
  final String name;
  final String image;
  final String type;
  String? id;

  Menu({
    required this.name,
    required this.image,
    required this.type,
    this.id,
  });

  factory Menu.fromMap(Map<String, dynamic> json) => Menu(
        name: json['name'],
        image: json['image'],
        type: json['type'],
        id: json['id'],
      );

  factory Menu.fromJson(String str) => Menu.fromMap(json.decode(str));

  Map<String, dynamic> toMap() => {
        'name': name,
        'image': image,
        'type': type,
        'id': id,
      };

  String toJson() => json.encode(toMap());

  String toJsonWithoutId() {
    Map<String, dynamic> data = {
      'name': name,
      'image': image,
      'type': type,
    };
    return json.encode(data);
  }
}
