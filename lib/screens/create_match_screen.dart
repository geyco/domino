import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme.dart';
import '../models/player.dart';
import '../providers/league_provider.dart';
import '../providers/match_provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/glass_card.dart';
import 'live_match_screen.dart';

class CreateMatchScreen extends StatefulWidget {
  const CreateMatchScreen({super.key});

  @override
  State<CreateMatchScreen> createState() => _CreateMatchScreenState();
}

class _CreateMatchScreenState extends State<CreateMatchScreen> {
  Player? _playerA1;
  Player? _playerA2;
  Player? _playerB1;
  Player? _playerB2;
  int _selectedLimit = 200;

  final List<int> _limits = [100, 150, 200, 300];

  @override
  void initState() {
    super.initState();
    // Autoseleccionar los primeros 4 jugadores si están disponibles
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final league = Provider.of<LeagueProvider>(context, listen: false);
      if (league.players.length >= 4) {
        setState(() {
          _playerA1 = league.players[0];
          _playerA2 = league.players[1];
          _playerB1 = league.players[2];
          _playerB2 = league.players[3];
        });
      }
    });
  }

  void _startMatch() {
    if (_playerA1 == null || _playerA2 == null || _playerB1 == null || _playerB2 == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor selecciona los 4 jugadores.')),
      );
      return;
    }

    final uniquePlayers = {_playerA1!.id, _playerA2!.id, _playerB1!.id, _playerB2!.id};
    if (uniquePlayers.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Un jugador no puede estar en múltiples posiciones.')),
      );
      return;
    }

    final league = Provider.of<LeagueProvider>(context, listen: false);
    final teamA = league.getOrCreateTeam(_playerA1!, _playerA2!);
    final teamB = league.getOrCreateTeam(_playerB1!, _playerB2!);

    final matchProvider = Provider.of<MatchProvider>(context, listen: false);
    matchProvider.startMatch(teamA, teamB, _selectedLimit);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LiveMatchScreen()),
    );
  }

  Widget _buildPlayerDropdown({
    required String label,
    required Player? value,
    required List<Player> players,
    required ValueChanged<Player?> onChanged,
    required Color accentColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: accentColor, fontWeight: FontWeight.bold, fontSize: 13)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: DominoTheme.cardColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<Player>(
              value: value,
              isExpanded: true,
              dropdownColor: DominoTheme.cardColor,
              style: const TextStyle(color: Colors.white, fontSize: 15),
              hint: const Text('Elegir Jugador', style: TextStyle(color: DominoTheme.textMuted)),
              icon: Icon(Icons.keyboard_arrow_down, color: accentColor),
              items: players.map((Player p) {
                return DropdownMenuItem<Player>(
                  value: p,
                  child: Text(p.name),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final league = Provider.of<LeagueProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva Partida', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: league.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Equipo A Card
                  GlassCard(
                    borderColor: DominoTheme.neonBlue.withOpacity(0.3),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: DominoTheme.neonBlue.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'Equipo A',
                            style: TextStyle(color: DominoTheme.neonBlue, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _buildPlayerDropdown(
                                label: 'Jugador 1',
                                value: _playerA1,
                                players: league.players,
                                onChanged: (val) => setState(() => _playerA1 = val),
                                accentColor: DominoTheme.neonBlue,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildPlayerDropdown(
                                label: 'Jugador 2',
                                value: _playerA2,
                                players: league.players,
                                onChanged: (val) => setState(() => _playerA2 = val),
                                accentColor: DominoTheme.neonBlue,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // VS Separador
                  const Center(
                    child: CircleAvatar(
                      backgroundColor: Colors.white12,
                      radius: 20,
                      child: Text(
                        'VS',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white70),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Equipo B Card
                  GlassCard(
                    borderColor: DominoTheme.neonRed.withOpacity(0.3),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: DominoTheme.neonRed.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'Equipo B',
                            style: TextStyle(color: DominoTheme.neonRed, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _buildPlayerDropdown(
                                label: 'Jugador 3',
                                value: _playerB1,
                                players: league.players,
                                onChanged: (val) => setState(() => _playerB1 = val),
                                accentColor: DominoTheme.neonRed,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildPlayerDropdown(
                                label: 'Jugador 4',
                                value: _playerB2,
                                players: league.players,
                                onChanged: (val) => setState(() => _playerB2 = val),
                                accentColor: DominoTheme.neonRed,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Límite de Puntos
                  const Text(
                    'Meta de Puntos',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: _limits.map((limit) {
                      final isSelected = _selectedLimit == limit;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedLimit = limit),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            height: 45,
                            decoration: BoxDecoration(
                              color: isSelected ? DominoTheme.gold.withOpacity(0.2) : DominoTheme.cardColor,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isSelected ? DominoTheme.gold : Colors.white.withOpacity(0.08),
                                width: 1.5,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                '$limit pts',
                                style: TextStyle(
                                  color: isSelected ? DominoTheme.gold : Colors.white70,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 40),
                  CustomButton(
                    text: 'Comenzar Partida',
                    gradientColors: const [Color(0xFFFFA000), Color(0xFFFFB300)],
                    onPressed: _startMatch,
                  ),
                ],
              ),
            ),
    );
  }
}
