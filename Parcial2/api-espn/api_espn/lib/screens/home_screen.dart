import 'package:flutter/material.dart';
import '../models/game_model.dart';
import '../services/api_service.dart';
import '../widgets/game_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Game>> _gamesFuture;

  @override
  void initState() {
    super.initState();
    _gamesFuture = ApiService().fetchGames();
  }

  // Permite recargar la lista haciendo pull-to-refresh
  Future<void> _refreshGames() async {
    setState(() {
      _gamesFuture = ApiService().fetchGames();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NFL Scoreboard'),
        centerTitle: true,
        backgroundColor: const Color(0xFF013369), // Azul clásico de la NFL
        foregroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshGames,
        child: FutureBuilder<List<Game>>(
          future: _gamesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error al cargar los datos.\n${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No hay partidos programados.'));
            }

            final games = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.only(top: 8, bottom: 20),
              itemCount: games.length,
              itemBuilder: (context, index) {
                return GameCard(game: games[index]);
              },
            );
          },
        ),
      ),
    );
  }
}