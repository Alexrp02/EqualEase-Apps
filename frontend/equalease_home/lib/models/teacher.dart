import 'dart:convert';

class Teacher {
  String id;
  String name;
  String surname;
  String email;
  List<String> students;
  String profilePicture; // Agregar la propiedad para la imagen de perfil.
  bool isAdmin;

  Teacher(
      {required this.id,
      required this.name,
      required this.surname,
      required this.email,
      required this.students,
      required this.profilePicture,
      required this.isAdmin});

  factory Teacher.fromMap(Map<String, dynamic> json) => Teacher(
      id: json['id'],
      name: json['name'],
      surname: json['surname'],
      email: json['email'],
      students: List<String>.from(json['students']),
      profilePicture: json['profilePicture'],
      isAdmin: json['isAdmin']);

  factory Teacher.fromJson(String str) => Teacher.fromMap(json.decode(str));

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'surname': surname,
      'email': email,
      'students': students,
      'profilePicture': profilePicture,
      'isAdmin': isAdmin
    };
  }

  String toJson() => json.encode(toMap());

  String toJsonWithoutId() {
    Map<String, dynamic> data = {
      'name': name,
      'surname': surname,
      'email': email,
      'students': students,
      'profilePicture': profilePicture,
      'isAdmin': isAdmin
    };
    return json.encode(data);
  }

  // ... Resto del código ...
}
