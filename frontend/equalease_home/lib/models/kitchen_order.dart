import 'dart:convert';

class KitchenOrder {
  final String classroom;
  final bool revised;
  final List<Map<String, dynamic>> orders;

  KitchenOrder(
      {required this.classroom, required this.revised, required this.orders});

  factory KitchenOrder.fromMap(Map<String, dynamic> json) => KitchenOrder(
        classroom: json['classroom'],
        revised: json['revised'],
        orders: List<Map<String, dynamic>>.from(json['orders']),
      );

  factory KitchenOrder.fromJson(String str) =>
      KitchenOrder.fromMap(json.decode(str));

  Map<String, dynamic> toMap() => {
        'classroom': classroom,
        'revised': revised,
        'orders': orders,
      };

  String toJson() => json.encode(toMap());
}
