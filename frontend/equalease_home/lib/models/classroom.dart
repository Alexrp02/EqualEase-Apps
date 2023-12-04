import 'dart:convert';

class Classroom {
  final String letter;
  final String assignedTeacher;
  final String? id;

  Classroom({
    required this.letter,
    required this.assignedTeacher,
    this.id,
  });

  factory Classroom.fromMap(Map<String, dynamic> json) => Classroom(
        letter: json['letter'],
        assignedTeacher: json['assignedTeacher'],
        id: json['id'],
      );

  Map<String, dynamic> toMap() => {
        'letter': letter,
        'assignedTeacher': assignedTeacher,
      };

  factory Classroom.fromJson(String str) => Classroom.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());
}
