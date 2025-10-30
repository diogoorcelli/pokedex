import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex/features/domain/usecases/get_pokemom_usecase.dart';
import 'package:pokedex/features/presentation/cubits/pokemom_list_state.dart';

class PokemonListCubit extends Cubit<PokemonListState> {
  final GetPokemomUseCase _getPokemomUseCase;
  static const _pageSize = 40;

  PokemonListCubit(this._getPokemomUseCase) : super(const PokemonListState());

  Future<void> loadFirstPage() async {
    emit(state.copyWith(status: PokemonListStatus.loading),);

    final result = await _getPokemomUseCase(const PokemonPageParams(offset: 0, limit: _pageSize),);

    result.fold(
      (failure) {
        emit(state.copyWith(status: PokemonListStatus.failure, errorMessage: failure.message),);
      },
      (pokemons) {
        emit(state.copyWith(
          status: PokemonListStatus.success,
          items: pokemons,
          hasMore: pokemons.length == _pageSize,
          nextOffset: _pageSize,
        ),);
      },
    );
  }

  Future<void> loadNextPage() async {
    if (!state.hasMore || state.status == PokemonListStatus.loadingMore) return;

    emit(state.copyWith(status: PokemonListStatus.loadingMore),);

    final result = await _getPokemomUseCase(PokemonPageParams(offset: state.nextOffset, limit: _pageSize),);

    result.fold(
      (failure) {
        emit(state.copyWith(status: PokemonListStatus.failure, errorMessage: failure.message),);
      },
      (pokemons) {
        final allPokemons = List.of(state.items)..addAll(pokemons);
        emit(state.copyWith(
          status: PokemonListStatus.success,
          items: allPokemons,
          hasMore: pokemons.length == _pageSize,
          nextOffset: state.nextOffset + _pageSize,
        ),);
      },
    );
  }
  

  
}