import 'dart:convert';

List<Ability> abilityFromJson(String str) =>
    List<Ability>.from(json.decode(str).map((x) => Ability.fromJson(x)));

String abilityToJson(List<Ability> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Ability {
  int id;
  String name;
  String description;

  Ability({
    required this.id,
    required this.name,
    required this.description
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }

  factory Ability.fromJson(Map<String, dynamic> json) {
    return Ability(
        id: json['id'],
        name: json['name'],
        description: json['description']);
  }
}