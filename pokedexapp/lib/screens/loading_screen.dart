import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pokedexapp/screens/list_screen.dart';

import '../models/ability_model.dart';
import '../models/pmab_relation_model.dart';
import '../models/pokemon_image_model.dart';
import '../models/pokemon_model.dart';
import '../models/type_model.dart';
import '../services/api_service.dart';
import '../utils/database_helper.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  LoadingScreenState createState() => LoadingScreenState();
}

class LoadingScreenState extends State<LoadingScreen> {
  late Future<void> _dataLoadingFuture;
  final apiService = ApiService();
  final dbHelper = DatabaseHelper.instance;

  @override
  void initState() {
    super.initState();
    _dataLoadingFuture = _loadData();
  }

  Future<void> _loadData() async {

    try {
      final lastFetchTime = await dbHelper.getLastFetchTime();
      final shouldFetchFromApi = await _shouldFetchFromApi(lastFetchTime);
      if (shouldFetchFromApi) {
        await _fetchFromApiAndUpdateDb();
      }
    } catch (e) {
      print('Error loading data: $e');
    }
  }

  Future<bool> _shouldFetchFromApi(DateTime? lastFetchTime) async {
    // Check network connectivity, if no connection don't try to fetch
    var connectivityResult = await (Connectivity().checkConnectivity());
    if(connectivityResult == ConnectivityResult.none) return false;

    // If can not find last fetch time in metadata db, always fetch
    if (lastFetchTime == null) return true;

    // over 24 hrs since last fetch time, fetch otherwise use local db
    final now = DateTime.now();
    final difference = now.difference(lastFetchTime);
    return difference.inHours >= 24;
  }

  Future<void> _clearAllTables() async {
    await dbHelper.deleteAllAbilities();
    await dbHelper.deleteAllPokemons();
    await dbHelper.deleteAllTypes();
    await dbHelper.deleteAllPokemonAbilityRelations();
    await dbHelper.deleteAllPokemonImages();
  }

  Future<void> _loadAbilities() async {
    List<AbilityModel> apiAbilities = await apiService.getAllAbilities();
    await dbHelper.createAbilities(apiAbilities);
  }

  Future<void> _loadPokemons() async {
    List<PokemonModel> apiPokemons = await apiService.getAllPokemons();
    await dbHelper.createPokemons(apiPokemons);
  }

  Future<void> _loadPokemonAbilityRelations() async {
    List<PmabRelationModel> apiPokemonAbilityRelations = await apiService.getAllPmabRelations();
    await dbHelper.createPokemonAbilityRelations(apiPokemonAbilityRelations);
  }

  Future<void> _loadPokemonTypes() async {
    List<TypeModel> apiTypes = await apiService.getAllTypes();
    await dbHelper.createTypes(apiTypes);
  }

  Future<void> _loadPokemonImages() async {
    List<PokemonImageModel> apiImages = await apiService.getAllPokemonImages();
    await dbHelper.createPokemonImages(apiImages);
  }

  Future<void> _loadAllDataFromAPI() async {
    await _loadAbilities();
    await _loadPokemons();
    await _loadPokemonAbilityRelations();
    await _loadPokemonTypes();
    await _loadPokemonImages();
  }

  Future<void> _fetchFromApiAndUpdateDb() async {
    await _clearAllTables();

    await _loadAllDataFromAPI();

    await dbHelper.updateLastFetchTime();

    print("loading finish!");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.redAccent,
      body: FutureBuilder(
        future: _dataLoadingFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // Data loaded, navigate to HomeScreen
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const ListScreen()),
              );
            });
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                    child: LottieBuilder.asset("assets/Lottie/splash_pikachu.json",
                      width: 300,
                      height: 300,
                    )
                ),
                AnimatedTextKit(
                  animatedTexts: [
                    WavyAnimatedText(
                      "Loading...",
                      textStyle: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber
                      ),
                      speed: const Duration(milliseconds: 50)
                    )
                  ],
                  repeatForever: true,

                ),
              ],
            ),
          );
        },
      ),
    );
  }
}