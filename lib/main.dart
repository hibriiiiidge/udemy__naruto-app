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
  List<Character> _characters = [];

  @override
  void initState() {
    super.initState();
    _fetchCharacters();
  }

  Future<void> _fetchCharacters() async {
    final response = await Dio().get(_apiUrl);
    final List<dynamic> data = response.data["characters"];
    setState(() {
      _characters = data.map((character) => Character.fromJson(character)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Naruto図鑑'),
          backgroundColor: Color(0xFFBCE2E8),
        ),
        body: Padding(
          padding: EdgeInsets.all(16),
          child: ListView.builder(
            itemCount: _characters.length,
            itemBuilder: (context, index) {
              final character = _characters[index];

              return Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Image.network(
                        character.images[0],
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Image(
                            image: AssetImage('assets/dummy.png'),
                            fit: BoxFit.contain,
                          );
                        },
                      )
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text( character.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                      child: Text(
                        character.debut?['appearsIn'] ?? 'なし',
                        style: TextStyle(fontSize: 14.0),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
