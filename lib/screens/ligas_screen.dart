import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme.dart';
import '../providers/league_provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/glass_card.dart';

class LigasScreen extends StatefulWidget {
  const LigasScreen({super.key});

  @override
  State<LigasScreen> createState() => _LigasScreenState();
}

class _LigasScreenState extends State<LigasScreen> {
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _showAddPlayerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: DominoTheme.cardColor,
          title: const Text('Agregar Jugador a la Liga', style: TextStyle(fontWeight: FontWeight.bold)),
          content: TextField(
            controller: _nameController,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Nombre completo',
              hintStyle: const TextStyle(color: DominoTheme.textMuted),
              filled: true,
              fillColor: Colors.black26,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancelar', style: TextStyle(color: Colors.white70)),
              onPressed: () {
                _nameController.clear();
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('Agregar', style: TextStyle(color: DominoTheme.gold, fontWeight: FontWeight.bold)),
              onPressed: () {
                final name = _nameController.text.trim();
                if (name.isNotEmpty) {
                  Provider.of<LeagueProvider>(context, listen: false).addPlayer(name);
                  _nameController.clear();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Jugador "$name" agregado con éxito.')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final league = Provider.of<LeagueProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Liga', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_alt_1, color: DominoTheme.gold),
            tooltip: 'Agregar Jugador',
            onPressed: () => _showAddPlayerDialog(context),
          ),
        ],
      ),
      body: league.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Banner "Viernes de Liga"
                  GlassCard(
                    borderColor: DominoTheme.neonBlue.withOpacity(0.3),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today, color: DominoTheme.neonBlue, size: 40),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Viernes de Liga',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Registra victorias, derrotas y rota jugadores dinámicamente.',
                                style: TextStyle(color: DominoTheme.textMuted, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Fila Cabecera Jugadores
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Miembros de la Liga (${league.players.length})',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      TextButton.icon(
                        icon: const Icon(Icons.add, size: 16, color: DominoTheme.gold),
                        label: const Text('Agregar', style: TextStyle(color: DominoTheme.gold, fontSize: 13)),
                        onPressed: () => _showAddPlayerDialog(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Lista de Jugadores
                  Expanded(
                    child: league.players.isEmpty
                        ? Center(
                            child: Text(
                              'Aún no hay jugadores registrados.',
                              style: TextStyle(color: Colors.white.withOpacity(0.35)),
                            ),
                          )
                        : ListView.builder(
                            itemCount: league.players.length,
                            itemBuilder: (context, index) {
                              final player = league.players[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: DominoTheme.cardColor,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.white.withOpacity(0.04)),
                                  ),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 16,
                                        backgroundColor: DominoTheme.neonBlue.withOpacity(0.1),
                                        child: Text(
                                          player.name.substring(0, 1).toUpperCase(),
                                          style: const TextStyle(color: DominoTheme.neonBlue, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      const SizedBox(width: 14),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              player.name,
                                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              'Récord: ${player.wins}G - ${player.losses}P',
                                              style: const TextStyle(color: DominoTheme.textMuted, fontSize: 11),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Estadísticas extras
                                      Row(
                                        children: [
                                          const Icon(Icons.star, color: DominoTheme.gold, size: 14),
                                          const SizedBox(width: 4),
                                          Text(
                                            '${player.capicuas} Cap.',
                                            style: const TextStyle(color: DominoTheme.gold, fontSize: 12, fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
    );
  }
}
