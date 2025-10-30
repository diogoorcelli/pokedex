import 'package:flutter/material.dart';
import 'package:pokedex/features/domain/entities/pokemom.dart';

class PokemonCard extends StatelessWidget {
  final Pokemon pokemon;
  final Color? backgroundColor;

  const PokemonCard({super.key, required this.pokemon, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    final bg = (backgroundColor ?? Colors.white).withOpacity(0.18);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: (backgroundColor ?? Colors.white).withOpacity(0.12),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            (backgroundColor ?? Colors.white).withOpacity(0.25),
            (backgroundColor ?? Colors.white).withOpacity(0.05),
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1.6,
              child: Center(
                child: Image.network(pokemon.imageUrl, fit: BoxFit.contain),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    _titleCase(pokemon.name),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '#${pokemon.id.toString().padLeft(3, '0')}',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _titleCase(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}
