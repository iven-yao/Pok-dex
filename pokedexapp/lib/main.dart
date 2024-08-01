import 'package:flutter/material.dart';
import 'package:pokedexapp/screens/loading_screen.dart';
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
      title: "Pokedex",
      initialRoute: 'home',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.redAccent)
      ),
      routes: {
        'home': (BuildContext context) => const LoadingScreen(),
      },
    );
  }
}