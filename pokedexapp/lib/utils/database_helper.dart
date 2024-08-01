import 'dart:async';

import 'package:pokedexapp/models/pmab_relation_model.dart';
import 'package:pokedexapp/models/pokemon_image_model.dart';
import 'package:pokedexapp/models/type_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/ability_model.dart';
import '../models/pokemon_model.dart';


class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if(_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final databasePath = await getDatabasesPath();
    final path = join( databasePath, "pokedex.db");
    return await openDatabase(path, version: 1, onOpen: _createDB);
  }

  Future<void> _createDB(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS abilities (
        id INTEGER PRIMARY KEY,
        name TEXT,
        description TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS types (
        id INTEGER PRIMARY KEY,
        name TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS pokemon_ability (
        id INTEGER PRIMARY KEY,
        pokemon_id INTEGER,
        ability_id INTEGER,
        is_hidden BOOLEAN
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS pokemons (
        id INTEGER PRIMARY KEY,
        name TEXT,
        type_1 TEXT,
        type_2 TEXT,
        hp INTEGER,
        attack INTEGER,
        defense INTEGER,
        special_attack INTEGER,
        special_defense INTEGER,
        speed INTEGER,
        image_url TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS pokemon_images (
        id INTEGER PRIMARY KEY,
        pokemon_id INTEGER,
        description TEXT,
        image_url TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS metadata(
        key TEXT PRIMARY KEY,
        value TEXT
      )
    ''');

    return;
  }

  Future<void> updateLastFetchTime() async {
    final db = await instance.database;
    await db.insert(
      'metadata',
      {'key': 'last_fetch_time', 'value': DateTime.now().toIso8601String()},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<DateTime?> getLastFetchTime() async {
    final db = await instance.database;
    final result = await db.query(
      'metadata',
      where: 'key = ?',
      whereArgs: ['last_fetch_time'],
    );
    if (result.isNotEmpty) {
      return DateTime.parse(result.first['value'] as String);
    }
    return null;
  }

  // Abilities ----------------------------------------------------------------
  Future<int> deleteAllAbilities() async {
    final db = await instance.database;
    final res = await db.rawDelete('DELETE FROM abilities');

    return res;
  }

  Future<void> createAbilities(List<AbilityModel> abilities) async {
    final db = await instance.database;

    // begin transaction
    await db.transaction((txn) async {
      Batch batch = txn.batch();

      for(var ability in abilities) {
        batch.insert('abilities', ability.toJson());
      }

      await batch.commit();
    });
  }

  Future<List<AbilityModel>> getAbilities() async {
    final db = await instance.database;
    final maps = await db.query('abilities');

    return List.generate(maps.length, (i) => AbilityModel.fromJson(maps[i]));
  }

  // Pokemons -----------------------------------------------------------------

  Future<int> deleteAllPokemons() async {
    final db = await instance.database;
    final res = await db.rawDelete('DELETE FROM pokemons');

    return res;
  }

  Future<void> createPokemons(List<PokemonModel> pokemons) async {
    final db = await instance.database;

    // begin transaction
    await db.transaction((txn) async {
      Batch batch = txn.batch();

      for(var pokemon in pokemons) {
        batch.insert('pokemons', pokemon.toJson());
      }

      await batch.commit();
    });
  }

  Future<List<PokemonModel>> getPokemons({int page = 1, int pageSize = 20}) async {
    final db = await instance.database;
    final offset = (page - 1) * pageSize;
    final maps = await db.query(
      'pokemons',
      limit: pageSize,
      offset: offset,
      orderBy: 'id ASC'
    );

    return List.generate(maps.length, (i) => PokemonModel.fromJson(maps[i]));
  }

  // Types --------------------------------------------------------------------
  Future<int> deleteAllTypes() async {
    final db = await instance.database;
    final res = await db.rawDelete('DELETE FROM types');

    return res;
  }

  Future<void> createTypes(List<TypeModel> types) async {
    final db = await instance.database;

    // begin transaction
    await db.transaction((txn) async {
      Batch batch = txn.batch();

      for(var type in types) {
        batch.insert('types', type.toJson());
      }

      await batch.commit();
    });
  }

  Future<List<TypeModel>> getPokemonTypes() async {
    final db = await instance.database;
    final maps = await db.query('types');

    return List.generate(maps.length, (i) => TypeModel.fromJson(maps[i]));
  }

  // PMABRelations ------------------------------------------------------------
  Future<int> deleteAllPokemonAbilityRelations() async {
    final db = await instance.database;
    final res = await db.rawDelete('DELETE FROM pokemon_ability');

    return res;
  }

  Future<void> createPokemonAbilityRelations(List<PmabRelationModel> relations) async {
    final db = await instance.database;

    // begin transaction
    await db.transaction((txn) async {
      Batch batch = txn.batch();

      for(var relation in relations) {
        batch.insert('pokemon_ability', relation.toJson());
      }

      await batch.commit();
    });
  }

  // PokemonImages ------------------------------------------------------------
  Future<int> deleteAllPokemonImages() async {
    final db = await instance.database;
    final res = await db.rawDelete(('DELETE FROM pokemon_images'));

    return res;
  }

  Future<void> createPokemonImages(List<PokemonImageModel> pmImages) async {
    final db = await instance.database;

    await db.transaction((txn) async {
      Batch batch = txn.batch();

      for(var pmImage in pmImages) {
        batch.insert('pokemon_images', pmImage.toJson());
      }

      await batch.commit();
    });
  }
}