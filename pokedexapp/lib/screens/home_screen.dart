import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:pokedexapp/models/pmab_relation_model.dart';
import 'package:pokedexapp/models/pokemon_model.dart';
import 'package:pokedexapp/models/type_model.dart';
import '../models/ability_model.dart';
import '../utils/database_helper.dart';
import '../services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final dbHelper = DatabaseHelper.instance;
  final apiService = ApiService();
  List<PokemonModel> pokemons = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final lastFetchTime = await dbHelper.getLastFetchTime();
      print(lastFetchTime);
      final shouldFetchFromApi = await _shouldFetchFromApi(lastFetchTime);
      print(shouldFetchFromApi);
      if (shouldFetchFromApi) {
        await _fetchFromApiAndUpdateDb();
      } else {
        await _loadFromDb();
      }
    } catch (e) {
      print('Error loading data: $e');
      await _loadFromDb();
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<bool> _shouldFetchFromApi(DateTime? lastFetchTime) async {
    if (lastFetchTime == null) return true;

    final now = DateTime.now();
    final difference = now.difference(lastFetchTime);

    // Check if it's been more than 24 hour since the last fetch
    if (difference.inHours >= 24) return true;

    // Check network connectivity
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }

  Future<void> _clearAllTables() async {
    await dbHelper.deleteAllAbilities();
    await dbHelper.deleteAllPokemons();
    await dbHelper.deleteAllTypes();
    await dbHelper.deleteAllPokemonAbilityRelations();
  }

  Future<void> _fetchFromApiAndUpdateDb() async {
    await _clearAllTables();

    List<AbilityModel> apiAbilities = await apiService.getAllAbilities();
    List<PokemonModel> apiPokemons = await apiService.getAllPokemons();
    List<PmabRelationModel> apiPokemonAbilityRelations = await apiService.getAllPmabRelations();
    List<TypeModel> apiTypes = await apiService.getAllTypes();

    await dbHelper.createAbilities(apiAbilities);
    await dbHelper.createPokemons(apiPokemons);
    await dbHelper.createPokemonAbilityRelations(apiPokemonAbilityRelations);
    await dbHelper.createTypes(apiTypes);

    await dbHelper.updateLastFetchTime();

    print("loading finish!");
    await _loadFromDb();
  }

  Future<void> _loadFromDb() async {
    List<PokemonModel> fetchedPokemon = await dbHelper.getPokemons(pageSize: 1025);
    setState(() {
      pokemons = fetchedPokemon;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Homescreen')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: pokemons.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(pokemons[index].name),
            subtitle: Text(pokemons[index].image_url),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        onPressed: _loadData,
      ),
    );
  }
}