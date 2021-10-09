import 'dart:convert';

class PlansModel {
  int id;
  DateTime createdAt;
  int impressions;
  String name;
  num price;
  List<String> vantages;
  String description;
  PlansModel({
    required this.id,
    required this.createdAt,
    required this.impressions,
    required this.name,
    required this.price,
    required this.vantages,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'interactions': impressions,
      'name': name,
      'price': price,
      'vantages': vantages,
      'description': description,
    };
  }

  factory PlansModel.fromMap(Map<String, dynamic> map) {
    return PlansModel(
      id: map['id'],
      createdAt: DateTime.parse(map['created_at']),
      impressions: map['interactions'],
      name: map['name'],
      price: map['price'],
      vantages: List<String>.from(map['vantages']),
      description: map['description'],
    );
  }

  String toJson() => json.encode(toMap());

  factory PlansModel.fromJson(String source) => PlansModel.fromMap(json.decode(source));
}
