import 'dart:convert';

class KitchenOrder {
  final String classroom;
  final bool revised;
  final List<Map<String, dynamic>> orders;
  final String date;
  final String? id;

  KitchenOrder(
      {required this.classroom,
      required this.revised,
      required this.orders,
      required this.date,
      this.id});

  factory KitchenOrder.fromMap(Map<String, dynamic> json) => KitchenOrder(
        classroom: json['classroom'],
        revised: json['revised'],
        orders: List<Map<String, dynamic>>.from(json['orders']),
        date: json['date'],
        id: json['id'],
      );

  factory KitchenOrder.fromJson(String str) =>
      KitchenOrder.fromMap(json.decode(str));

  Map<String, dynamic> toMap() => {
        'classroom': classroom,
        'revised': revised,
        'orders': orders,
        'date': date,
      };

  String toJson() => json.encode(toMap());

  String toJsonWithoutId() {
    Map<String, dynamic> map = toMap();
    map.remove('id');
    return json.encode(map);
  }
}
