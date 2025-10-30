import 'package:equatable/equatable.dart';
import 'package:pokedex/features/domain/entities/pokemom.dart';

enum PokemonListStatus { initial, loading, success, failure, loadingMore }

class PokemonListState extends Equatable {
  final PokemonListStatus status;
  final List<Pokemon> items;
  final bool hasMore;
  final int nextOffset;
  final String errorMessage;

  const PokemonListState({
    this.status = PokemonListStatus.initial,
    this.items = const [],
    this.hasMore = false,
    this.nextOffset = 0,
    this.errorMessage = '',
  });

  int get displayCount =>
      items.length + ((status == PokemonListStatus.loadingMore) ? 1 : 0);

  PokemonListState copyWith({
    PokemonListStatus? status,
    List<Pokemon>? items,
    bool? hasMore,
    int? nextOffset,
    String? errorMessage,
  }) {
    return PokemonListState(
      status: status ?? this.status,
      items: items ?? this.items,
      hasMore: hasMore ?? this.hasMore,
      nextOffset: nextOffset ?? this.nextOffset,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [status, items, hasMore, nextOffset, errorMessage];
}
