import 'package:floor/floor.dart';
import 'package:prova3/data/poke.dart';

@dao
abstract class PokemonDao {
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertPokemon(Pokemon pokemon);

  @Query('DELETE FROM pokemon WHERE id = :id')
  Future<void> deletePokemonById(int id);

  @Query('SELECT * FROM pokemon')
  Future<List<Pokemon>> findAllPokemons();

  @Query('SELECT * FROM pokemon WHERE id = :id')
  Future<Pokemon?> findPokemonById(int id);
}
