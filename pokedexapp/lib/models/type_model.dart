import 'dart:convert';

List<TypeModel> abilityFromJson(String str) =>
    List<TypeModel>.from(json.decode(str).map((x) => TypeModel.fromJson(x)));

String abilityToJson(List<TypeModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TypeModel {
  int id;
  String name;

  TypeModel({
    required this.id,
    required this.name
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name
    };
  }

  factory TypeModel.fromJson(Map<String, dynamic> json) {
    return TypeModel(
        id: json['id'],
        name: json['name']
    );
  }
}