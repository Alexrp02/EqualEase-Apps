import 'dart:convert';

class Kitchen {
  final String assignedStudent;
  final List<String> orders;
  final String date;

  Kitchen(
      {required this.assignedStudent,
      required this.orders,
      required this.date});

  factory Kitchen.fromMap(Map<String, dynamic> json) => Kitchen(
        assignedStudent: json['assignedStudent'],
        orders: List<String>.from(json['orders']),
        date: json['date'],
      );

  factory Kitchen.fromJson(String str) => Kitchen.fromMap(json.decode(str));

  Map<String, dynamic> toMap() => {
        'assignedStudent': assignedStudent,
        'orders': orders,
        'date': date,
      };

  String toJson() => json.encode(toMap());
}
