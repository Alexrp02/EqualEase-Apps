import 'dart:convert';

class Item {
  String id;
  String name;
  String pictogram;
  int quantity;
  String size;

  Item({
    required this.id,
    required this.name,
    required this.pictogram,
    required this.quantity,
    required this.size,
  });

  factory Item.fromMap(Map<String, dynamic> json) => Item(
      id: json['id'],
      name: json['name'],
      pictogram: json['pictogram'],
      quantity: json['quantity'],
      size: json['size']);

  factory Item.fromJson(String str) => Item.fromMap(json.decode(str));

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'pictogram': pictogram,
      'quantity': quantity,
      'size': size
    };
  }

  String toJson() => json.encode(toMap());

  // Necesario cuando se quiera crear una nueva tarea, puesto
  // que el id es asignado automáticamente
  String toJsonWithoutId() {
    Map<String, dynamic> data = {
      'name': name,
      'pictogram': pictogram,
      'quantity': quantity,
      'size': size
    };
    return json.encode(data);
  }
}
