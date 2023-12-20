import 'dart:async';
import 'package:floor/floor.dart';
import 'package:prova3/data/poke.dart';
import 'package:prova3/data/poke_dao.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
part 'poke_database.g.dart';

@Database(version: 2, entities: [Pokemon])
abstract class AppDatabase extends FloorDatabase {
  PokemonDao get pokemonDao;
}

final migration1to2 = Migration(1, 2, (database) async {
  final databasePath = database.path;

  await sqflite.deleteDatabase(databasePath);
  await sqflite.openDatabase(databasePath);
});
