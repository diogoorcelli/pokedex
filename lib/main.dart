import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex/core/di/service_locator.dart';
import 'package:pokedex/features/presentation/cubits/pokemom_list_cubit.dart';
import 'package:pokedex/features/presentation/views/pokedex_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.red),
      home: BlocProvider(
        create: (_) => getIt<PokemonListCubit>(),
        child: const PokedexPage(),
      ),
    );
  }
}
