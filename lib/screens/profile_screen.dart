import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme.dart';
import '../models/player.dart';
import '../providers/league_provider.dart';
import '../widgets/glass_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final league = Provider.of<LeagueProvider>(context);

    // Buscar a Juan Pérez en los jugadores para mostrar sus estadísticas dinámicas
    final Player juan = league.players.firstWhere(
      (p) => p.id == 'juan',
      orElse: () => Player(id: 'guest', name: 'Invitado', photoUrl: '', wins: 0, losses: 0),
    );

    // Filtrar el historial para ver partidas donde participó Juan Pérez
    final userMatches = league.matchHistory.where((m) {
      return m.teamA.player1.id == juan.id ||
          m.teamA.player2.id == juan.id ||
          m.teamB.player1.id == juan.id ||
          m.teamB.player2.id == juan.id;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: league.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Card Perfil Principal (Tipo Juan Pérez en el mockup)
                  GlassCard(
                    borderColor: DominoTheme.gold.withOpacity(0.3),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            // Bandera RD y Avatar
                            Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                CircleAvatar(
                                  radius: 36,
                                  backgroundColor: DominoTheme.gold.withOpacity(0.2),
                                  child: const Icon(Icons.person, size: 40, color: DominoTheme.gold),
                                ),
                                // Bandera RD miniatura
                                Container(
                                  width: 24,
                                  height: 16,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white, width: 1.5),
                                    borderRadius: BorderRadius.circular(2),
                                    image: const DecorationImage(
                                      // Bandera simplificada usando degradado de colores de RD
                                      image: NetworkImage('https://flagcdn.com/w80/do.png'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 16),
                            // Nombre y Nivel
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    juan.name,
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: const [
                                      Icon(Icons.military_tech, color: DominoTheme.gold, size: 18),
                                      SizedBox(width: 4),
                                      Text(
                                        'Nivel: Pro',
                                        style: TextStyle(
                                          color: DominoTheme.gold,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // Estadísticas Dashboard (Ganadas, Capicúas, P. Corrido)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStatItem('Ganadas', '${juan.wins}'),
                            _buildVerticalDivider(),
                            _buildStatItem('Capicúas', '${juan.capicuas}'),
                            _buildVerticalDivider(),
                            _buildStatItem('P. Corrido', '${juan.pasosCorridos}'),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Historial de Partidas del Jugador
                  const Text(
                    'Historial de Partidas',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  Expanded(
                    child: userMatches.isEmpty
                        ? Center(
                            child: Text(
                              'Aún no has jugado partidas registradas.',
                              style: TextStyle(color: Colors.white.withOpacity(0.35)),
                            ),
                          )
                        : ListView.builder(
                            itemCount: userMatches.length,
                            itemBuilder: (context, index) {
                              final match = userMatches[index];
                              final isTeamA = match.teamA.player1.id == juan.id || match.teamA.player2.id == juan.id;
                              final userTeam = isTeamA ? match.teamA : match.teamB;
                              final opponentTeam = isTeamA ? match.teamB : match.teamA;
                              
                              final userScore = isTeamA ? match.scoreA : match.scoreB;
                              final opponentScore = isTeamA ? match.scoreB : match.scoreA;

                              final isWin = match.winnerTeamId == userTeam.id;

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: DominoTheme.cardColor,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isWin
                                          ? DominoTheme.neonGreen.withOpacity(0.2)
                                          : DominoTheme.neonRed.withOpacity(0.2),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      // Status Victoria / Derrota
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: isWin
                                              ? DominoTheme.neonGreen.withOpacity(0.15)
                                              : DominoTheme.neonRed.withOpacity(0.15),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          isWin ? 'GANÓ' : 'PERDIÓ',
                                          style: TextStyle(
                                            color: isWin ? DominoTheme.neonGreen : DominoTheme.neonRed,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      // Rivales y Marcador
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Contra: ${opponentTeam.displayName}',
                                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'Compañero: ${userTeam.player1.id == juan.id ? userTeam.player2.name : userTeam.player1.name}',
                                              style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 11),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Marcador
                                      Text(
                                        '$userScore - $opponentScore',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: isWin ? DominoTheme.neonGreen : Colors.white70,
                                        ),
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

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: DominoTheme.textMuted,
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      width: 1,
      height: 35,
      color: Colors.white.withOpacity(0.1),
    );
  }
}
