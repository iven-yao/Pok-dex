
import 'package:flutter/material.dart';
import 'package:pokedexapp/services/api_service.dart';
import 'package:pokedexapp/utils/database_helper.dart';

import '../models/ability_model.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  final dbHelper = DatabaseHelper.instance;
  final apiService = ApiService();
  List<AbilityModel> abilities = [];
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

    try{
      List<AbilityModel> apiAbilities = await apiService.getAllAbilities();
      await _refreshAbilityList();
    } catch(e) {
      print('Error loading data: $e');
      // if API failed, try to load from SQLite
      await _refreshAbilityList();
    }

    setState(() {
      isLoading = false;
    });
  }

  // fetch abilities from SQLite
  Future<void> _refreshAbilityList() async {
    List<AbilityModel> fetchedAbilities = await dbHelper.getAbilities();
    setState(() {
      abilities =  fetchedAbilities;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pokedex')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: abilities.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(abilities[index].name),
            subtitle: Text(abilities[index].description),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _loadData,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}