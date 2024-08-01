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