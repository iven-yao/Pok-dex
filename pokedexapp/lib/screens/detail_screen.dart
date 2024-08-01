import 'package:flutter/material.dart';
import 'package:pokedexapp/models/pokemon_model.dart';
import 'package:pokedexapp/utils/string_helper.dart';

class PokemonDetailScreen extends StatefulWidget {
  final PokemonModel pokemon;

  const PokemonDetailScreen({super.key, required this.pokemon});

  @override
  PokemonDetailScreenState createState() => PokemonDetailScreenState();
}

class PokemonDetailScreenState extends State<PokemonDetailScreen> {
  bool isLiked = false;

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
                child: Image.network(
                  widget.pokemon.image_url,
                  height: 200,
                  width: 200,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'ID: #${widget.pokemon.id}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text('Type 1: ${widget.pokemon.type_1}'),
              if (widget.pokemon.type_2 != null)
                Text('Type 2: ${widget.pokemon.type_2}'),
              const SizedBox(height: 16),
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      isLiked ? Icons.favorite : Icons.favorite_border,
                      color: isLiked ? Colors.red : null,
                    ),
                    onPressed: () {
                      setState(() {
                        isLiked = !isLiked;
                      });
                    },
                  ),
                  Text(isLiked ? 'Liked' : 'Like'),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCommentsDialog(context);
        },
        child: const Icon(Icons.comment),
        backgroundColor: Colors.redAccent,
      ),
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