import 'package:floor/floor.dart';

@Entity(tableName: 'pokemon')
class Pokemon {
  @primaryKey
  final int id;
  final String name;
  final int altura;
  final int peso;
  final String imageUrl;
  final String vidaBase;

  Pokemon(
      {required this.id,
      required this.name,
      required this.altura,
      required this.peso,
      required this.imageUrl,
      required this.vidaBase});
}
