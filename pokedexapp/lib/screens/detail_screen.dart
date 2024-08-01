import 'package:flutter/material.dart';
import 'package:pokedexapp/components/type_badge.dart';
import 'package:pokedexapp/models/pokemon_image_model.dart';
import 'package:pokedexapp/models/pokemon_model.dart';
import 'package:pokedexapp/utils/string_helper.dart';

import '../components/ability_card.dart';
import '../components/image_gallery.dart';
import '../components/main_image.dart';
import '../components/stats_chart.dart';
import '../models/ability_model.dart';
import '../models/comment_model.dart';
import '../services/api_service.dart';
import '../utils/database_helper.dart';

class PokemonDetailScreen extends StatefulWidget {
  final PokemonModel pokemon;

  const PokemonDetailScreen({super.key, required this.pokemon});

  @override
  PokemonDetailScreenState createState() => PokemonDetailScreenState();
}

class PokemonDetailScreenState extends State<PokemonDetailScreen> {
  final dbHelper = DatabaseHelper.instance;
  final apiService = ApiService();
  List<AbilityModel> abilities = [];
  List<PokemonImageModel> images = [];
  bool isLoading = false;
  // not yet implemented
  bool isLiked = false;
  // not yet implemented
  List<CommentModel> comments = [];

  @override
  void initState() {
    super.initState();
    _loadFromDb();
  }

  Future<void> _loadFromDb() async {
    setState(() {
      isLoading = true;
    });
    List<AbilityModel> fetchedAbilities = await dbHelper.getAbilitiesByPokemonId(widget.pokemon.id);
    List<PokemonImageModel> fetchedImages = await dbHelper.getImagesByPokemonId(widget.pokemon.id);
    setState(() {
      abilities = fetchedAbilities;
      images = fetchedImages;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Pokédex",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.amber,
          ),
        ),
        backgroundColor: Colors.redAccent,
        leading:
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.amber,),
            onPressed: () => Navigator.pop(context),
          )
        ,
        leadingWidth: 30,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    StringHelper.transformPokemonName(widget.pokemon.name),
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  Text(
                    StringHelper.formatId(widget.pokemon.id),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey
                    ),
                  )
                ],
              ),
              Center(
                child: PokemonMainImage(
                  imageUrl: widget.pokemon.image_url,
                  type1: widget.pokemon.type_1,
                  type2: widget.pokemon.type_2,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TypeBadge(type: widget.pokemon.type_1),
                  if(widget.pokemon.type_2 != null) TypeBadge(type: widget.pokemon.type_2!)
                ],
              ),
              AdditionalImageGallery(images: images),
              PokemonStatsChart(pokemon: widget.pokemon),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  'Abilities',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: abilities.length,
                itemBuilder: (context, index) {
                  return AbilityCard(ability: abilities[index]);
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomRight,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton.small(
                shape: const CircleBorder(),
                heroTag: 'like',
                onPressed: () {
                  setState(() {
                    isLiked = !isLiked;
                });
                },
                backgroundColor: Colors.white,
                child: Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border,
                  color: isLiked ? Colors.red : null,
                ),
              ),
              const SizedBox(height: 4),
              FloatingActionButton.small(
                shape: const CircleBorder(),
                heroTag: 'comment',
                onPressed: () {
                  // Show comment dialog or navigate to comment screen
                  _showCommentsDialog(context);
                },
                backgroundColor: Colors.white,
                child: const Icon(Icons.comment),
              ),
            ],
          ),
        ),
      )
    );
  }

  void _showCommentsDialog(BuildContext context) {
    List<String> comments = [];
    TextEditingController commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Comments'),
              content: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: comments.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(comments[index]),
                          );
                        },
                      ),
                    ),
                    TextField(
                      controller: commentController,
                      decoration: InputDecoration(
                        hintText: 'Add a comment...',
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.send),
                          onPressed: () {
                            if (commentController.text.isNotEmpty) {
                              setState(() {
                                comments.add(commentController.text);
                                commentController.clear();
                              });
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Close'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}