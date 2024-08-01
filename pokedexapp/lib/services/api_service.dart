import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pokedexapp/models/pmab_relation_model.dart';
import 'package:pokedexapp/models/pokemon_image_model.dart';
import 'package:pokedexapp/models/type_model.dart';
import 'package:pokedexapp/utils/database_helper.dart';
import '../models/ability_model.dart';
import '../models/pokemon_model.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8080/api';

  Future<List<AbilityModel>> getAllAbilities() async {
    final response = await http.get(Uri.parse('$baseUrl/ability'));
    if(response.statusCode == 200) {
      DatabaseHelper.instance.deleteAllAbilities();

      List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((obj) => AbilityModel.fromJson(obj)).toList();
    } else {
      throw Exception("Failed to load Abilities");
    }
  }

  Future<List<PokemonModel>> getAllPokemons() async {
    final response = await http.get(Uri.parse('$baseUrl/pokemon'));
    if(response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((obj) => PokemonModel.fromJson(obj)).toList();
    } else {
      throw Exception("Failed to load Pokemons");
    }
  }

  Future<List<TypeModel>> getAllTypes() async {
    final response = await http.get(Uri.parse('$baseUrl/type'));
    if(response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((obj) => TypeModel.fromJson(obj)).toList();
    } else {
      throw Exception("Failed to load Types");
    }
  }

  Future<List<PmabRelationModel>> getAllPmabRelations() async {
    final response = await http.get(Uri.parse('$baseUrl/pokemon_ability'));
    if(response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((obj) => PmabRelationModel.fromJson(obj)).toList();
    } else {
      throw Exception("Failed to load Pokemon-Ability Relations");
    }
  }

  Future<List<PokemonImageModel>> getAllPokemonImages() async {
    final response = await http.get(Uri.parse('$baseUrl/pokemon_image'));
    if(response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((obj) => PokemonImageModel.fromJson(obj)).toList();
    } else {
      throw Exception("Failed to load Pokemon Images");
    }
  }
}