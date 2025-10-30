import 'package:pokedex/features/domain/entities/pokemom.dart';

class PokemonModel {
  final String name;
  final String url;

  PokemonModel({
    required this.name,
    required this.url,
  });

  factory PokemonModel.fromJson(Map<String, dynamic> json) {
    return PokemonModel(
      name: json['name'],
      url: json['url'],
    );
  }

  int get id => int.parse(url.split('/').where((element) => element.isNotEmpty).last);

  Pokemon toEntity() {
    return Pokemon(
      id: id,
      name: name,
      imageUrl:'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png',
    );
  }
}