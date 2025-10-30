import 'package:pokedex/core/network/http_client.dart';
import 'package:pokedex/features/data/models/pokemom_model.dart';

abstract class IPokemomRemoteDataSource {
  Future<List<PokemonModel>> getPokemonPage({
    required int offset,
    required int limit,
  });
}

class PokemomRemoteDatasource implements IPokemomRemoteDataSource {
  final IHttpClient httpClient;

  PokemomRemoteDatasource({required this.httpClient});

  static const String _endpoint = '/pokemon';

  @override
  Future<List<PokemonModel>> getPokemonPage({
    required int offset,
    required int limit,
  }) async {
    final response = await httpClient.get(
      _endpoint,
      queryParameters: {
        'offset': offset,
        'limit': limit,
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao ao buscar pokémons');
    }

    final results = response.data['results'] as List;
    return results.map((e) => PokemonModel.fromJson(e)).toList();
  }
}
