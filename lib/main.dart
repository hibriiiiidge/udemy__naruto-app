import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:udemy__naruto_app/modules/characters/character.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _apiUrl = "http://localhost/character";

  @override
  void initState() {
    super.initState();
    _fetchCharacters();
  }

  Future<void> _fetchCharacters() async {
    final response = await Dio().get(_apiUrl);
    final List<dynamic> data = response.data["characters"];
    final characters = data.map((character) => Character.fromJson(character)).toList();
    print(characters);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NARUTO 図鑑'),
      ),
      body: Container()
    );
  }
}
