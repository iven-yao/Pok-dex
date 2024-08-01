class PokemonImageModel {
  int id;
  int pokemon_id;
  String description;
  String image_url;

  PokemonImageModel({
    required this.id,
    required this.pokemon_id,
    required this.description,
    required this.image_url
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pokemon_id': pokemon_id,
      'description': description,
      'image_url': image_url
    };
  }

  factory PokemonImageModel.fromJson(Map<String, dynamic> json) {
    return PokemonImageModel(
      id: json['id'],
      pokemon_id: json['pokemon_id'],
      description: json['description'],
      image_url: json['image_url']
    );
  }
}