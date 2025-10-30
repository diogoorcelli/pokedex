import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex/features/presentation/cubits/pokemom_list_cubit.dart';
import 'package:pokedex/features/presentation/cubits/pokemom_list_state.dart';
import 'package:pokedex/features/presentation/widgets/pokemom_cards.dart';
import '../../../../core/utils/responsive_grid_delegate.dart';

class PokedexPage extends StatefulWidget {
  const PokedexPage({super.key});

  @override
  State<PokedexPage> createState() => _PokedexPageState();
}

class _PokedexPageState extends State<PokedexPage> {
  final _scrollCtrl = ScrollController();
  final _searchCtrl = TextEditingController();
  String _selectedType = 'all';

  @override
  void initState() {
    super.initState();
    context.read<PokemonListCubit>().loadFirstPage();
    _scrollCtrl.addListener(() {
      if (_scrollCtrl.position.pixels >=
          _scrollCtrl.position.maxScrollExtent - 600) {
        context.read<PokemonListCubit>().loadNextPage();
      }
    });
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 64,
        centerTitle: false,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        titleSpacing: 16,
        title: Row(
          children: [
            const _LogoPoke(),
            const SizedBox(width: 12),
            Text(
              'Pokédex',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Favoritos',
            onPressed: () {},
            icon: const Icon(Icons.favorite_border),
          ),
          IconButton(
            tooltip: 'Perfil',
            onPressed: () {},
            icon: const Icon(Icons.person_outline),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final isListLayout = ResponsiveGridDelegate.isList(width);
          final crossAxisCount = ResponsiveGridDelegate.columnsForWidth(width);
          final horizontalPadding = _horizontalPadding(width);

          return CustomScrollView(
            controller: _scrollCtrl,
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Qual Pokémon você está procurando?',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 16),
                      _SearchField(
                        controller: _searchCtrl,
                        hint: 'Buscar por nome ou número',
                        onClear: () {
                          _searchCtrl.clear();
                          setState(() {});
                        },
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
              BlocBuilder<PokemonListCubit, PokemonListState>(
                builder: (context, state) {
                  if (state.status == PokemonListStatus.loading &&
                      state.items.isEmpty) {
                    return const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  if (state.status == PokemonListStatus.failure) {
                    return SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding,
                          vertical: 24,
                        ),
                        child: Text(
                          state.errorMessage,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    );
                  }

                  final filtered = state.items;

                  if (isListLayout) {
                    return SliverPadding(
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding,
                        vertical: 8,
                      ),
                      sliver: SliverList.builder(
                        itemCount:
                            filtered.length +
                            (state.status == PokemonListStatus.loadingMore
                                ? 1
                                : 0),
                        itemBuilder: (_, i) {
                          if (i >= filtered.length) {
                            return const Padding(
                              padding: EdgeInsets.all(16),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }
                          final pokemon = filtered[i];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: PokemonCard(pokemon: pokemon),
                          );
                        },
                      ),
                    );
                  }

                  return SliverPadding(
                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      8,
                      horizontalPadding,
                      24,
                    ),
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        childAspectRatio: 3 / 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, i) {
                          if (i >= filtered.length) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          final pokemon = filtered[i];
                          return PokemonCard(pokemon: pokemon);
                        },
                        childCount:
                            filtered.length +
                            (state.status == PokemonListStatus.loadingMore
                                ? 1
                                : 0),
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

double _horizontalPadding(double width) {
  if (width >= 1280) return (width - 1100) / 2;
  if (width >= 1024) return 32;
  if (width >= 600) return 20;
  return 16;
}

class _SearchField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final VoidCallback onClear;
  final ValueChanged<String> onChanged;

  const _SearchField({
    required this.controller,
    required this.hint,
    required this.onClear,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: const Icon(Icons.search),
        suffixIcon: controller.text.isNotEmpty
            ? IconButton(icon: const Icon(Icons.close), onPressed: onClear)
            : null,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.black.withOpacity(0.06)),
        ),
      ),
    );
  }
}

class _LogoPoke extends StatelessWidget {
  const _LogoPoke();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.red,
      ),
      child: Center(
        child: Container(
          width: 10,
          height: 10,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
