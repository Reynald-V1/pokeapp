import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:prova3/data/poke.dart';
import 'dart:convert';
import 'package:prova3/data/poke_database.dart' as pokedata;
import 'package:prova3/data/poke_database.dart';
import 'package:prova3/pages/telasobre.dart';

class TelaCaptura extends StatefulWidget {
  const TelaCaptura({super.key});

  @override
  State<TelaCaptura> createState() => _TelaCapturaState();
}

class _TelaCapturaState extends State<TelaCaptura> {
  final String apiUrl = 'https://pokeapi.co/api/v2/pokemon?limit=1018';
  ConnectivityResult _connectivityResult = ConnectivityResult.none;

  Future<Map<String, dynamic>> fetchData(String url) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Falha ao carregar os dados');
    }
  }

  Future<void> _checkConnectivity() async {
    final result = await Connectivity().checkConnectivity();
    setState(() {
      _connectivityResult = result;
    });
  }

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    Connectivity().onConnectivityChanged.listen((result) {
      setState(() {
        _connectivityResult = result;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amberAccent,
      appBar: AppBar(
        title: const Text('tela de captura'),
        actions: [
          IconButton(
              icon: const Icon(Icons.info),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Telasobre()));
              })
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchData(apiUrl),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (_connectivityResult == ConnectivityResult.none) {
            return const Center(child: Text('Erro de conexão'));
          } else {
            final results = snapshot.data!['results'] as List<dynamic>;
            return ListView.builder(
              itemCount: 6,
              itemBuilder: (context, index) {
                Random randomIndex = Random();
                final pokemon = results[randomIndex.nextInt(results.length)];
                final pokemonUrl = pokemon['url'];

                return FutureBuilder<Map<String, dynamic>>(
                  future: fetchData(pokemonUrl),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.connectionState ==
                        ConnectionState.none) {
                      return Center(child: Text('Erro: ${snapshot.error}'));
                    } else {
                      final name = snapshot.data?['name'];
                      final height = snapshot.data?['height'];
                      final abilities = snapshot.data?['abilities'];
                      final weight = snapshot.data?['weight'];
                      final id = snapshot.data?['id'];
                      final imageUrl =
                          snapshot.data?['sprites']['front_default'];

                      final List<dynamic> stats = snapshot.data?['stats'];
                      // Find the stat with 'name' equal to 'hp' (hit points)
                      final hpStat = stats.firstWhere(
                        (stat) => stat['stat']['name'] == 'hp',
                        orElse: () => {
                          'base_stat': null
                        }, // Default value if 'hp' stat is not found
                      );

                      final baseLife = hpStat != null
                          ? hpStat['base_stat']?.toString()
                          : null;

                      return Container(
                        color: const Color.fromARGB(255, 255, 106, 7),
                        child: ListTile(
                          title: Text('Nome: $name' ' id:$id'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              imageUrl != null
                                  ? Image.network(imageUrl)
                                  : const CircularProgressIndicator(),
                              Text('vida base:$baseLife'),
                              Text('Altura: $height decímetros'),
                              Text(
                                  'Habilidades: ${abilities.map((ability) => ability['ability']['name']).join(', ')}'),
                              Text('Peso: $weight hectogramas'),

                              //botão para salvar
                              ElevatedButton(
                                onPressed: () async {
                                  final pokemonEntity = Pokemon(
                                    id: id,
                                    name: name,
                                    altura: height,
                                    peso: weight,
                                    imageUrl: imageUrl ?? '',
                                    vidaBase: baseLife ?? '',
                                  );

                                  final database = await pokedata
                                      .$FloorAppDatabase
                                      .databaseBuilder('app_database.db')
                                      .addMigrations([migration1to2]).build();

                                  await database.pokemonDao
                                      .insertPokemon(pokemonEntity);
                                  SnackBar(content: Text('voce pegou $name'));
                                },
                                child: const Icon(Icons.save),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
