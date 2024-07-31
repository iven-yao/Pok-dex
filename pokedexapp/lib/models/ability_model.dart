import 'dart:convert';

List<AbilityModel> abilityFromJson(String str) =>
    List<AbilityModel>.from(json.decode(str).map((x) => AbilityModel.fromJson(x)));

String abilityToJson(List<AbilityModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AbilityModel {
  int id;
  String name;
  String description;

  AbilityModel({
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

  factory AbilityModel.fromJson(Map<String, dynamic> json) {
    return AbilityModel(
        id: json['id'],
        name: json['name'],
        description: json['description']);
  }
}