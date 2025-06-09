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
  final _limit = 10;
  final _controller = ScrollController();
  int _page = 1;
  bool _isLoading = false;

  List<Character> _characters = [];

  @override
  void initState() {
    super.initState();
    _fetchCharacters();
    _controller.addListener(() {
      if (_controller.position.maxScrollExtent - 100< _controller.offset) {
        _fetchCharacters();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Future<void> _fetchCharacters() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });
    final response = await Dio().get( _apiUrl, queryParameters: { "page": _page, "limit": _limit });
    final List<dynamic> data = response.data["characters"];

    setState(() {
      _characters = [..._characters, ...data.map((character) => Character.fromJson(character)).toList()];
      _page++;
      _isLoading = false;
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
            controller: _controller,
            itemCount: _characters.length,
            itemBuilder: (context, index) {
              final character = _characters[index];

              return Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: character.images.isNotEmpty
                        ? Image.network(
                            character.images[0],
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Image(
                                image: AssetImage('assets/dummy.png'),
                                fit: BoxFit.contain,
                              );
                            },
                          )
                        : Image(
                            image: AssetImage('assets/dummy.png'),
                            fit: BoxFit.contain,
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
