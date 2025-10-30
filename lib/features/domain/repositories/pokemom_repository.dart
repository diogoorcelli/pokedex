import 'package:dartz/dartz.dart';
import 'package:pokedex/core/errors/failures.dart';
import 'package:pokedex/features/domain/entities/pokemom.dart';

abstract class IPokemonRepository {
  Future<Either<Failure, List<Pokemon>>> getPokemonPage({
    required int offset,
    required int limit,
  });
}