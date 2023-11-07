import 'dart:convert';

class Teacher {
  String id;
  String name;
  String surname;
  String email;
  List<String> students;
  String profilePicture; // Agregar la propiedad para la imagen de perfil.

  Teacher({
    required this.id,
    required this.name,
    required this.surname,
    required this.email,
    required this.students,
    required this.profilePicture,
  });

  factory Teacher.fromMap(Map<String, dynamic> json) => Teacher(
        id: json['id'],
        name: json['name'],
        surname: json['surname'],
        email: json['email'],
        students: List<String>.from(json['students']),
        profilePicture: json['profilePicture'],
      );

  factory Teacher.fromJson(String str) => Teacher.fromMap(json.decode(str));

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'surname': surname,
      'email': email,
      'students': students,
      'profilePicture': profilePicture,
    };
  }

  String toJson() => json.encode(toMap());

  // ... Resto del código ...
}
