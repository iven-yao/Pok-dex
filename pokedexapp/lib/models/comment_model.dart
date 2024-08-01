class CommentModel {
  int id;
  String username;
  int pokemon_id;
  String content;
  DateTime created_at;

  CommentModel({
    required this.id,
    required this.username,
    required this.pokemon_id,
    required this.content,
    required this.created_at
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'pokemon_id' : pokemon_id,
      'content' : content,
      'created_at' : created_at,
    };
  }

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'],
      username: json['username'],
      pokemon_id: json['pokemon_id'],
      content: json['content'],
      created_at: json['created_at'],
    );
  }
}