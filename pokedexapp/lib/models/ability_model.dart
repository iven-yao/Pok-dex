class AbilityModel {
  int id;
  String name;
  String description;
  int? is_hidden;

  AbilityModel({
    required this.id,
    required this.name,
    required this.description,
    this.is_hidden
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description
    };
  }

  factory AbilityModel.fromJson(Map<String, dynamic> json) {
    return AbilityModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      is_hidden: json['is_hidden']
    );

  }
}