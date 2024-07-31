import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:pokedexapp/screens/home_screen.dart';
import 'package:pokedexapp/screens/list_screen.dart';
import 'package:sqflite/sqflite.dart';

void main(){
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

Future<void> deleteDatabase(String path) =>
    databaseFactory.deleteDatabase(path);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: 'home',
      routes: {
        'home': (BuildContext context) => const HomeScreen(),
      },
    );
  }
}