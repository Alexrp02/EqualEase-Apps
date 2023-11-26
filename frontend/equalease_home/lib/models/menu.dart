import 'dart:convert';

class Menu {
  final String name;
  final String image;
  final String type;

  Menu({
    required this.name,
    required this.image,
    required this.type,
  });

  factory Menu.fromMap(Map<String, dynamic> json) => Menu(
        name: json['name'],
        image: json['image'],
        type: json['type'],
      );

  factory Menu.fromJson(String str) => Menu.fromMap(json.decode(str));

  Map<String, dynamic> toMap() => {
        'name': name,
        'image': image,
        'type': type,
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
