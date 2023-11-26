import 'dart:convert';

import 'package:equalease_home/models/kitchen_order.dart';

class Kitchen {
  final String assignedStudent;
  final List<KitchenOrder> orders;
  final String date;

  Kitchen(
      {required this.assignedStudent,
      required this.orders,
      required this.date});

  factory Kitchen.fromMap(Map<String, dynamic> json) => Kitchen(
        assignedStudent: json['assignedStudent'],
        orders: List<KitchenOrder>.from(
            json['orders'].map((x) => KitchenOrder.fromMap(x))),
        date: json['date'],
      );

  factory Kitchen.fromJson(String str) => Kitchen.fromMap(json.decode(str));

  Map<String, dynamic> toMap() => {
        'assignedStudent': assignedStudent,
        'orders': List<dynamic>.from(orders.map((x) => x.toMap())),
        'date': date,
      };

  String toJson() => json.encode(toMap());
}
