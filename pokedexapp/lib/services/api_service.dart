import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pokedexapp/providers/db_provider.dart';
import '../models/ability.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8080/api';

  Future<List<Ability>> getAllAbilities() async {
    final response = await http.get(Uri.parse('$baseUrl/ability'));
    print(response);
    if(response.statusCode == 200) {

      dynamic jsonRes = json.decode(response.body);
      List<dynamic> jsonList = jsonRes["abilities"];
      return jsonList.map((json) {
        final newAbility = Ability.fromJson(json);
        print('Inserting $newAbility');
        DBProvider.db.createAbility(newAbility);
        return newAbility;
      }).toList();
    } else {
      throw Exception("Failed to load Abilities");
    }
  }
}