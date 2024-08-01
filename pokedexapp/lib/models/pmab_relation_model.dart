class PmabRelationModel {
  int id;
  int pokemon_id;
  int ability_id;
  int is_hidden;

  PmabRelationModel({
    required this.id,
    required this.pokemon_id,
    required this.ability_id,
    required this.is_hidden
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pokemon_id': pokemon_id,
      'ability_id': ability_id,
      'is_hidden': is_hidden
    };
  }

  factory PmabRelationModel.fromJson(Map<String, dynamic> json) {
    return PmabRelationModel(
        id: json['id'],
        pokemon_id: json['pokemon_id'],
        ability_id: json['ability_id'],
        is_hidden: json['is_hidden']? 1:0
    );
  }
}