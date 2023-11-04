import 'dart:convert';

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

  Student({
    required this.id,
    required this.name,
  });

  factory Student.fromMap(Map<String, dynamic> json) => Student(
        id: json['id'],
        name: json['name']
        // images: json['images'],
        // pictograms: json['pictograms']
  );

  factory Student.fromJson(String str) => Student.fromMap(json.decode(str));

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name
  };

  String toJson() => json.encode(toMap());

  // Necesario cuando se quiera crear una nueva tarea, puesto
  // que el id es asignado automáticamente
  String toJsonWithoutId() {
    Map<String, dynamic> data = {
      'name': name
      
    };
    return json.encode(data);
  }

}