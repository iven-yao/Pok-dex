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