import 'package:flutter/material.dart';
import 'package:pokedexapp/components/pokemon_list_item.dart';
import 'package:pokedexapp/models/pokemon_model.dart';
import 'package:pokedexapp/models/type_model.dart';
import '../utils/database_helper.dart';
import '../services/api_service.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  ListScreenState createState() => ListScreenState();
}

class ListScreenState extends State<ListScreen> {
  final dbHelper = DatabaseHelper.instance;
  final apiService = ApiService();
  List<PokemonModel> allPokemons = [];
  List<PokemonModel> filteredPokemons = [];
  List<TypeModel> allTypes = [];
  bool isLoading = false;
  int currentPage = 1;
  int itemsPerPage = 20;
  String sortBy = 'id';
  bool sortAscending = true;
  TypeModel? filterType;
  String? filterName;
  String? filterId;

  @override
  void initState() {
    super.initState();
    _loadFromDb();
  }

  Future<void> _loadFromDb() async {
    setState(() {
      isLoading = true;
    });
    List<PokemonModel> fetchedPokemon = await dbHelper.getPokemons(pageSize: 1025);
    List<TypeModel> fetchTypes = await dbHelper.getPokemonTypes();
    setState(() {
      allPokemons = fetchedPokemon;
      allTypes = fetchTypes;
      _applyFiltersAndSort();
      isLoading = false;
    });
  }

  void _applyFiltersAndSort() {
    filteredPokemons = List.from(allPokemons);

    // Apply filters
    if (filterType != null) {
      filteredPokemons = filteredPokemons.where((pokemon) => [pokemon.type_1, pokemon.type_2].contains(filterType?.name)).toList();
    }
    if (filterName != null) {
      filteredPokemons = filteredPokemons.where((pokemon) => pokemon.name.toLowerCase().contains(filterName!.toLowerCase())).toList();
    }
    if (filterId != null) {
      filteredPokemons = filteredPokemons.where((pokemon) => pokemon.id.toString().contains(filterId!)).toList();
    }

    // Apply sorting
    filteredPokemons.sort((a, b) {
      if (sortBy == 'id') {
        return sortAscending ? a.id.compareTo(b.id) : b.id.compareTo(a.id);
      } else {
        return sortAscending ? a.name.compareTo(b.name) : b.name.compareTo(a.name);
      }
    });

    setState(() {});
  }

  List<PokemonModel> _getPaginatedPokemons() {
    final startIndex = (currentPage - 1) * itemsPerPage;
    final endIndex = startIndex + itemsPerPage;
    return filteredPokemons.sublist(
      startIndex,
      endIndex > filteredPokemons.length ? filteredPokemons.length : endIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pokédex',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.amber
          ),
        ),
        backgroundColor: Colors.redAccent,
        leading: Container(
          margin: const EdgeInsets.only(left: 10),
         child: Image.asset("assets/Poke_Ball.webp"),
        ),
        leadingWidth: 30,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: _showSortDialog,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _getPaginatedPokemons().length,
              itemBuilder: (context, index) {
                return PokemonListItem(pokemonData: _getPaginatedPokemons()[index]);
              },
            ),
          ),
          _buildPagination(),
        ],
      ),
    );
  }

  Widget _buildPagination() {
    final totalPages = (filteredPokemons.length / itemsPerPage).ceil();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: currentPage > 1
              ? () {
            setState(() {
              currentPage--;
            });
          }
              : null,
        ),
        Text('$currentPage / $totalPages'),
        IconButton(
          icon: const Icon(Icons.arrow_forward),
          onPressed: currentPage < totalPages
              ? () {
            setState(() {
              currentPage++;
            });
          }
              : null,
        ),
      ],
    );
  }

  void _showFilterDialog() {
    final TextEditingController typeController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: const Text('Filter Pokémon'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownMenu<TypeModel>(
                  menuHeight: 200,
                  inputDecorationTheme: const InputDecorationTheme(
                    isDense: true
                  ),
                  expandedInsets: EdgeInsets.zero,
                  initialSelection: filterType,
                  controller: typeController,
                  label: const Text('Type'),
                  onSelected: (TypeModel? type) {
                    setState(() {
                      filterType = type;
                      filterId = null;
                      filterName = null;
                    });
                  },
                  dropdownMenuEntries: allTypes.map<DropdownMenuEntry<TypeModel>>((TypeModel type) {
                    return DropdownMenuEntry<TypeModel>(
                      value: type,
                      label: type.name
                    );
                  }).toList(),
                ),
                TextFormField(
                  initialValue: filterName,
                  decoration: const InputDecoration(labelText: 'Name'),
                  onChanged: (value) {
                    filterName = value.isEmpty ? null : value;
                    filterType = null;
                    filterId = null;
                  },
                ),
                TextFormField(
                  initialValue: filterId,
                  decoration: const InputDecoration(labelText: 'ID'),
                  onChanged: (value) {
                    filterId = value.isEmpty ? null : value;
                    filterName = null;
                    filterType = null;
                  },

                ),
              ],
            ),
            actions: [

              TextButton(
                child: const Text('Clear Filter'),
                onPressed: () {
                  setState(() {
                    filterType = null;
                    filterName = null;
                    filterId = null;
                  });
                  _applyFiltersAndSort();
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Apply'),
                onPressed: () {
                  _applyFiltersAndSort();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
      },
    );
  }

  void _showSortDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: const Text('Sort Pokémon'),
              content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile(
                  title: const Text('Sort by ID'),
                  value: 'id',
                  groupValue: sortBy,
                  onChanged: (value) {
                    setState(() {
                      sortBy = 'id';
                    });
                  },
                ),
                RadioListTile(
                  title: const Text('Sort by Name'),
                  value: 'name',
                  groupValue: sortBy,
                  onChanged: (value) {
                    setState(() {
                      sortBy = 'name';
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text('Ascending'),
                  value: sortAscending,
                  onChanged: (value) {
                    setState(() {
                      sortAscending = value!;
                    });
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                child: const Text('Apply'),
                onPressed: () {
                  _applyFiltersAndSort();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
      },
    );
  }
}