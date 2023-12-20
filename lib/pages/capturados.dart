import 'package:flutter/material.dart';
import 'package:prova3/data/poke.dart';
import 'package:prova3/data/poke_database.dart';
import 'package:prova3/pages/telasobre.dart';

class PokemonCapturados extends StatefulWidget {
  const PokemonCapturados({super.key});

  @override
  State<PokemonCapturados> createState() => _PokemonCapturadosState();
}

//get de pokemons da database
Future<List<Pokemon>> _getPokemons() async {
  final database =
      await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  final pokemonDao = database.pokemonDao;

  return pokemonDao.findAllPokemons();
}

class _PokemonCapturadosState extends State<PokemonCapturados> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokémon List'),
        actions: [
          IconButton(
              icon: const Icon(Icons.info),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Telasobre()));
              })
        ],
      ),
      body: FutureBuilder<List<Pokemon>>(
        //pega pokemons do banco e os coloca em snapshot
        future: _getPokemons(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final pokemons = snapshot.data;

            //listagem
            return ListView.builder(
              itemCount: pokemons!.length,
              itemBuilder: (context, index) {
                final pokemon = pokemons[index];

                return Container(
                  color: Colors.redAccent[700],
                  child: ListTile(
                    title: Text('Name: ${pokemon.name}'),
                    subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ignore: unnecessary_null_comparison
                          pokemon.imageUrl != null
                              ? Image.network(pokemon.imageUrl)
                              : const CircularProgressIndicator(),
                          Text(
                              'ID: ${pokemon.id} | altura: ${pokemon.altura} | peso: ${pokemon.peso} | vida:${pokemon.vidaBase}'),
                        ]),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
