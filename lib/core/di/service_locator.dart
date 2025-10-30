import 'package:get_it/get_it.dart';
import 'package:pokedex/core/network/dio_http_client.dart';
import 'package:pokedex/core/network/http_client.dart';
import 'package:pokedex/core/usecases/usecase.dart';
import 'package:pokedex/features/data/datasources/pokemom_remote_datasource.dart';
import 'package:pokedex/features/data/repositories/pokemom_repository_impl.dart';
import 'package:pokedex/features/domain/entities/pokemom.dart';
import 'package:pokedex/features/domain/repositories/pokemom_repository.dart';
import 'package:pokedex/features/domain/usecases/get_pokemom_usecase.dart';
import 'package:pokedex/features/presentation/cubits/pokemom_list_cubit.dart';

final getIt = GetIt.instance;

const _baseUrl = 'https://pokeapi.co/api/v2/';

void setupServiceLocator() {
  getIt.registerLazySingleton<IHttpClient>(
    () => DioHttpClient(baseUrl: _baseUrl),
  );
  getIt.registerLazySingleton<IPokemomRemoteDataSource>(
    () => PokemomRemoteDatasource(httpClient: getIt<IHttpClient>()),
  );
  getIt.registerLazySingleton<IPokemonRepository>(
    () => PokemonRepositoryImpl(
      remoteDataSource: getIt<IPokemomRemoteDataSource>(),
    ),
  );
  getIt.registerLazySingleton<GetPokemomUseCase>(
    () => GetPokemomUseCase(repository: getIt<IPokemonRepository>()),
  );
  getIt.registerFactory<PokemonListCubit>(
    () => PokemonListCubit(getIt<GetPokemomUseCase>()),
  );
}

void resetDependencies() => getIt.reset();
