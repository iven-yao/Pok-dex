import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:pokedexapp/services/api_service.dart';
import 'package:pokedexapp/utils/database_helper.dart';

import '../models/ability.dart';

class ListView extends StatefulWidget {
  @override
  _ListViewState createState() => _ListViewState();
}

class _ListViewState extends State<ListView> {
  final dbHelper = DatabaseHelper.instance;
  final apiService = ApiService();
  List<Ability> abilities = [];
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
      List<Ability> apiAbilities = await apiService.fetchAbilities();

      for(var ability in apiAbilities) {
        await dbHelper.insertAbility(ability);
      }

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
    List<Ability> fetchedAbilities = await dbHelper.getAbilities();
    setState(() {
      abilities =  fetchedAbilities;
    });
  }

  
}