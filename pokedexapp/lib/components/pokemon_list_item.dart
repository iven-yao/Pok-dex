import 'package:flutter/material.dart';
import 'package:pokedexapp/models/pokemon_model.dart';
import 'package:pokedexapp/utils/string_helper.dart';

import '../screens/detail_screen.dart';

class PokemonListItem extends StatelessWidget {
  final PokemonModel pokemonData;

  const PokemonListItem({super.key, required this.pokemonData});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: ListTile(
        visualDensity: const VisualDensity(vertical: 4),
        leading: FadeInImage(
          image:NetworkImage(pokemonData.image_url),
          placeholder: const AssetImage("assets/Poke_Ball.webp"),
          width: 80,
        ),
        title: Text(
          StringHelper.transformPokemonName(pokemonData.name),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold
          ),
        ),
        subtitle: Row(
          children: [
            Container(
              width: 60,
              margin: const EdgeInsets.fromLTRB(0, 0, 5, 0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Center(
               child: Text(pokemonData.type_1),
              ),
            ),
            if(pokemonData.type_2 != null) Container(
              width: 60,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Center(
                child: Text(pokemonData.type_2!),
              ),
            )
          ],

        ),
        trailing: Text('#${pokemonData.id}'),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PokemonDetailScreen(pokemon: pokemonData),
            ),
          );
        },
      ),
    );
  }
}