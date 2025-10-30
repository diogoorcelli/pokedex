import 'package:dartz/dartz.dart';
import 'package:pokedex/core/errors/exceptions.dart';
import 'package:pokedex/core/errors/failures.dart';
import 'package:pokedex/features/data/datasources/pokemom_remote_datasource.dart';
import 'package:pokedex/features/domain/entities/pokemom.dart';
import 'package:pokedex/features/domain/repositories/pokemom_repository.dart';

class PokemonRepositoryImpl implements IPokemonRepository {
  final IPokemomRemoteDataSource remoteDataSource;

  PokemonRepositoryImpl({required this.remoteDataSource});
  
  @override
  Future<Either<Failure, List<Pokemon>>> getPokemonPage({required int offset, required int limit}) async {
    try {
      final models = await remoteDataSource.getPokemonPage(offset: offset, limit: limit);
      final entities = models.map((m) => m.toEntity()).toList();
      return Right(entities);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return const Left(ServerFailure('Erro inesperado'));
    }
  } 
}