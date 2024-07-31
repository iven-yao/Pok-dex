
class Pokemon {
  final int id;
  final String name;
  final String type_1;
  final String? type_2;
  final int hp;
  final int attack;
  final int defense;
  final int special_attack;
  final int special_defense;
  final int speed;
  final String image_url;

  const Pokemon({
    required this.id,
    required this.name,
    required this.type_1,
    required this.type_2,
    required this.hp,
    required this.attack,
    required this.defense,
    required this.special_attack,
    required this.special_defense,
    required this.speed,
    required this.image_url
  });

  Map<String, dynamic> toJson() {
    return {
      'id':id,
      'name': name,
      'type_1':type_1,
      'type_2':type_2,
      'hp':hp,
      'attack':attack,
      'defense':defense,
      'special_attack': special_attack,
      'special_defense': special_defense,
      'speed':speed,
      'image_url':image_url
    };
  }

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
        id: json['id'],
        name: json['name'],
        type_1: json['type_1'],
        type_2: json['type_2'],
        hp: json['hp'],
        attack: json['attack'],
        defense: json['defense'],
        special_attack: json['special_attack'],
        special_defense: json['special_defense'],
        speed: json['speed'],
        image_url: json['image_url']
    );
  }
}