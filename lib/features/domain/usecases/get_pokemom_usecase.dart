import 'package:dartz/dartz.dart';
import 'package:pokedex/core/errors/failures.dart';
import 'package:pokedex/core/usecases/usecase.dart';
import 'package:pokedex/features/domain/entities/pokemom.dart';
import 'package:pokedex/features/domain/repositories/pokemom_repository.dart';

class GetPokemomUseCase extends UseCaseWithParams<List<Pokemon>, PokemonPageParams> {
  final IPokemonRepository repository;

  GetPokemomUseCase({required this.repository});

  @override
  Future<Either<Failure, List<Pokemon>>> call(PokemonPageParams params) {
    return repository.getPokemonPage(offset: params.offset, limit: params.limit);
  }

}

class PokemonPageParams {
  final int offset;
  final int limit;

  const PokemonPageParams({
    required this.offset,
    required this.limit,
  });
}